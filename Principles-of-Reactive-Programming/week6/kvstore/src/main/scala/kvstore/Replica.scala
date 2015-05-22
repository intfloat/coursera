package kvstore

import akka.actor.{ OneForOneStrategy, Props, ActorRef, Actor }
import akka.event.Logging
import akka.event.LoggingReceive
import kvstore.Arbiter._
import scala.collection.immutable.Queue
import akka.actor.SupervisorStrategy.Restart
import scala.annotation.tailrec
import akka.pattern.{ ask, pipe }
import akka.actor.Terminated
import scala.concurrent.duration._
import akka.actor.PoisonPill
import akka.actor.OneForOneStrategy
import akka.actor.SupervisorStrategy
import akka.util.Timeout

object Replica {
  sealed trait Operation {
    def key: String
    def id: Long
  }
  case class Insert(key: String, value: String, id: Long) extends Operation
  case class Remove(key: String, id: Long) extends Operation
  case class Get(key: String, id: Long) extends Operation

  sealed trait OperationReply
  case class OperationAck(id: Long) extends OperationReply
  case class OperationFailed(id: Long) extends OperationReply
  case class GetResult(key: String, valueOption: Option[String], id: Long) extends OperationReply

  def props(arbiter: ActorRef, persistenceProps: Props): Props = Props(new Replica(arbiter, persistenceProps))
}

class Replica(val arbiter: ActorRef, persistenceProps: Props) extends Actor {
  import Replica._
  import Replicator._
  import Persistence._
  import context.dispatcher

  /*
   * The contents of this actor is just a suggestion, you can implement it in any way you like.
   */
  
  var kv = Map.empty[String, String]

  // a map from secondary replicas to replicators
  var secondaries = Map.empty[ActorRef, ActorRef]

  // the current set of replicators
  var replicators = Set.empty[ActorRef]

  // the last acknowledged sequence number
  var lastAckSeq = -1L

  // the expected sequence number
  var expectedSeq = 0L

  var persister = context.actorOf(persistenceProps)
  context.watch(persister)

  // the outstanding persistence request sent by the secondary to persister
  var acks = Map.empty[Long, (ActorRef, Snapshot)]

  // the outstanding persistence request sent by the primary to persister
  var persists = Map.empty[Long, (ActorRef, Replicate)]

  // the outstanding persistence and replication requests waiting 
  // by the primary 
  var waitings = Map.empty[Long, (ActorRef, Set[ActorRef])]

  // replicator actorRef -> number of replicate requests waiting
  // by the primary
  var pendingReplicatorRequests = Map.empty[ActorRef, Int]

  // When a replicator is created, the primary must forward update events
  // it currently holds to the replicator
  // Replicator actorRef -> list of Replicate events
  var pendingReplicatorUpdates = Map.empty[ActorRef, List[Replicate]]

  val log = Logging(context.system, this)

  // sequence number used for persistence request
  var _seqCounter = 0L
  def nextSeq = {
    val ret = _seqCounter
    _seqCounter += 1
    ret
  }

  override val supervisorStrategy = OneForOneStrategy(maxNrOfRetries = 5) {
     case _: PersistenceException => SupervisorStrategy.Restart
  }

  context.system.scheduler.schedule(0.milliseconds, 50.milliseconds) {
    acks foreach { case (persistId, (_, Snapshot(key, valueOption, seq))) => {
        persister ! Persist(key, valueOption, persistId)
      }
    }
    persists foreach { case (persistId, (_, Replicate(key, valueOption, seq))) => {
        persister ! Persist(key, valueOption, persistId)
      }
    }
  }

  arbiter ! Join

  def receive = {
    case JoinedPrimary   => context.become(leader)
    case JoinedSecondary => context.become(replica)
  }

  /* TODO Behavior for  the leader role. */
  val leader: Receive = LoggingReceive {
    case Insert(key, value, id) => {
      kv += key -> value
      persistAndReplicate(sender, key, Some(value), id)
    }
    case Remove(key, id) => {
      kv -= key
      persistAndReplicate(sender, key, None, id)
    }
    case Get(key, id) => {
      val opt = kv.get(key)
      sender ! GetResult(key, opt, id)
    }
    case Replicas(replicas) => {
      val others = replicas - self
      val added = others filter { !secondaries.contains(_) }
      val removed = secondaries.keySet filter { others.isEmpty || others.contains(_) }
      added foreach { secondary => populateReplica(secondary) }
      removed foreach { secondary => stopReplica(secondary) }
    }
    case Persisted(key, persistId) => {
      if (persists contains persistId) {
        val persist = persists.get(persistId)
        persist match {
          case Some((client, Replicate(k, v, id))) => {
            persists -= persistId
            checkWaitings(id, persister)
          }
          case None => // do nothing
        }
      }
    }
    case Replicated(key, id) => {
      if (pendingReplicatorRequests contains sender) {
        checkReplicaReady(sender)
      } else {
        checkWaitings(id, sender)
      }
    }
  }

  // Persists in primary and replicate to secondaries
  // Schedule timeout if no confirmation after lapsed time
  def persistAndReplicate(client: ActorRef, key: String, value: Option[String], id: Long): Unit = {
    val persistId = nextSeq
    val replicate = Replicate(key, value, id)
    var waitingForAcks = Set.empty[ActorRef]
    replicators foreach { replicator => {
      replicator ! replicate 
      waitingForAcks += replicator
    }}
    pendingReplicatorRequests foreach {
      case (replicator, count) => {
        if (pendingReplicatorUpdates contains replicator) {
          val updates = pendingReplicatorUpdates.get(replicator)
          updates match {
            case Some(replicates) => {
              pendingReplicatorUpdates += replicator -> (replicates ::: List(replicate))
              waitingForAcks += replicator
            }
            case None => 
          }
        } else {
          pendingReplicatorUpdates += replicator -> List(replicate)
          waitingForAcks += replicator
        }
      }
    }
    persists += persistId -> (client, replicate)
    persister ! Persist(key, value, persistId)
    waitingForAcks += persister
    waitings += id -> (client, waitingForAcks)
    scheduleTimeout(client, id)
  }

  // Schedule timeout for persistence requests failed on either primary or secondaries
  // Send OperationFailed back to client
  def scheduleTimeout(client: ActorRef, id: Long): Unit = {
    context.system.scheduler.scheduleOnce(1.second) {
      if (waitings contains id) {
        waitings -= id
        client ! OperationFailed(id)
      }
    }
  }

  // Replicate primary data to secondary
  // If no primary data needs to be replicated, then secondary replica is ready
  def populateReplica(secondary: ActorRef): Unit = {
    var _seqCounter = 0L
    def nextSeq = {
      val ret = _seqCounter
      _seqCounter += 1
      ret
    }

    val replicator = context.actorOf(Replicator.props(secondary))
    context.watch(replicator)
    secondaries += secondary -> replicator

    val count = kv.size
    if (count > 0) {
      kv foreach { 
        case(key, value) => {
          replicator ! Replicate(key, Some(value), nextSeq)
        }
      }
      pendingReplicatorRequests += replicator -> count
    } else {
      replicators += replicator
    }
  }

  def stopReplica(secondary: ActorRef): Unit = {
    val r = secondaries.get(secondary)
    r match {
      case Some(replicator) => {
        waitings foreach { case (id, (client, waitingForAcks)) => {
          if (waitingForAcks contains replicator) {
            val remainWaitingForAcks = waitingForAcks - replicator
            if (remainWaitingForAcks.isEmpty) {
              waitings -= id
              client ! OperationAck(id)
            } else {
              waitings += id -> (client, remainWaitingForAcks)
            }
          }
        }}
        pendingReplicatorRequests -= replicator
        pendingReplicatorUpdates -= replicator
        secondaries -= secondary
        context.stop(persister)
        context.stop(replicator)
      }
      case None =>
    }
  }

  def checkReplicaReady(replicator: ActorRef): Unit = {
    val data = pendingReplicatorRequests.get(replicator)
    data match {
      case Some(count) => {
        if (count == 1) {
          pendingReplicatorRequests -= replicator
          if (pendingReplicatorUpdates contains replicator) {
            val updates = pendingReplicatorUpdates.get(replicator)
            updates match {
              case Some(replicates) => {
                replicates foreach { replicate => {
                  replicator ! replicate
                }}
              }
              case None =>
            }
          }
          replicators += replicator
        } else {
          pendingReplicatorRequests += replicator -> (count - 1)
        }
      }
      case None =>
    }
  }

  // Check if primary still waits for confirmation for persistence
  // If no longer waiting, send OperationAck back to client
  def checkWaitings(id: Long, responded: ActorRef): Unit = {
    if (waitings contains id) {
      val waiting = waitings.get(id)
      waiting match {
        case Some((client, waitingForAcks)) => {
          val remainingWaitingForAcks = waitingForAcks - responded
          if (remainingWaitingForAcks.isEmpty) {
            waitings -= id
            client ! OperationAck(id)
          } else {
            waitings += id -> (client, remainingWaitingForAcks)
          }
        }
        case None =>
      }
    }
  }

  /* TODO Behavior for the replica role. */
  val replica: Receive = LoggingReceive {
    case Get(key, id) => {
      val opt = kv.get(key)
      sender ! GetResult(key, opt, id)
    }
    case Snapshot(key, valueOption, seq) => {
      val expected = Math.max(expectedSeq, lastAckSeq + 1)
      if (seq < expected) {
        sender ! SnapshotAck(key, seq)
      } else if (seq == expected) {
        valueOption match {
          case Some(value) => { kv += key -> value }
          case None => { kv -= key }
        }
        val persistId = nextSeq
        acks += persistId -> (sender, Snapshot(key, valueOption, seq))
        persister ! Persist(key, valueOption, persistId)

        // schedule for timeout for persistence request
        context.system.scheduler.scheduleOnce(1.second) {
          if (acks contains persistId) {
            val ack = acks.get(persistId)
            ack match {
              case Some((replicator, Snapshot(k, v, seq))) => {
                acks -= persistId
              }
              case None => 
            }
          }
        }
      }
    }
    case Persisted(key, id) => {
      if (acks contains id) {
        val ack = acks.get(id)
        ack match {
          case Some((replicator, Snapshot(k, v, seq))) => {
            acks -= id
            lastAckSeq = seq
            expectedSeq = lastAckSeq + 1
            replicator ! SnapshotAck(key, seq)
          }
          case None => 
        }
      }
    }
  }

}
