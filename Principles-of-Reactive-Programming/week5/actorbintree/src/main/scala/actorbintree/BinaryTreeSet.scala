/**
 * Copyright (C) 2009-2013 Typesafe Inc. <http://www.typesafe.com>
 */
package actorbintree

import akka.actor._
import scala.collection.immutable.Queue

object BinaryTreeSet {

  trait Operation {
    def requester: ActorRef
    def id: Int
    def elem: Int
  }

  trait OperationReply {
    def id: Int
  }

  /** Request with identifier `id` to insert an element `elem` into the tree.
    * The actor at reference `requester` should be notified when this operation
    * is completed.
    */
  case class Insert(requester: ActorRef, id: Int, elem: Int) extends Operation

  /** Request with identifier `id` to check whether an element `elem` is present
    * in the tree. The actor at reference `requester` should be notified when
    * this operation is completed.
    */
  case class Contains(requester: ActorRef, id: Int, elem: Int) extends Operation

  /** Request with identifier `id` to remove the element `elem` from the tree.
    * The actor at reference `requester` should be notified when this operation
    * is completed.
    */
  case class Remove(requester: ActorRef, id: Int, elem: Int) extends Operation

  /** Request to perform garbage collection*/
  case object GC

  /** Holds the answer to the Contains request with identifier `id`.
    * `result` is true if and only if the element is present in the tree.
    */
  case class ContainsResult(id: Int, result: Boolean) extends OperationReply
  
  /** Message to signal successful completion of an insert or remove operation. */
  case class OperationFinished(id: Int) extends OperationReply

}


class BinaryTreeSet extends Actor {
  import BinaryTreeSet._
  import BinaryTreeNode._

  def createRoot: ActorRef = context.actorOf(BinaryTreeNode.props(0, initiallyRemoved = true))

  var root = createRoot

  // optional
  var pendingQueue = Queue.empty[Operation]

  // optional
  def receive = normal

  // optional
  /** Accepts `Operation` and `GC` messages. */
  val normal: Receive = {
    case Insert(requester, id, elem) => root ! Insert(requester, id, elem)
    case Contains(requester, id, elem) => root ! Contains(requester, id, elem)
    case Remove(requester, id, elem) => root ! Remove(requester, id, elem)
    case GC => {
      val newRoot = context.actorOf(BinaryTreeNode.props(0, true))
      context become garbageCollecting(newRoot)
      root ! CopyTo(newRoot)
    }
  }

  // optional
  /** Handles messages while garbage collection is performed.
    * `newRoot` is the root of the new binary tree where we want to copy
    * all non-removed elements into.
    */
  def garbageCollecting(newRoot: ActorRef): Receive = {
    case Insert(requester, id, elem) => pendingQueue = pendingQueue enqueue Insert(requester, id, elem)
    case Contains(requester, id, elem) => pendingQueue = pendingQueue enqueue Contains(requester, id, elem)
    case Remove(requester, id, elem) => pendingQueue = pendingQueue enqueue Remove(requester, id, elem)
    case CopyFinished => {
      root = newRoot
      while (!pendingQueue.isEmpty) {
        val (op, nqueue) = pendingQueue.dequeue
        root ! op
        pendingQueue = nqueue
      }
      context become normal
    }
  }

}

object BinaryTreeNode {
  trait Position

  case object Left extends Position
  case object Right extends Position

  case class CopyTo(treeNode: ActorRef)
  case object CopyFinished

  def props(elem: Int, initiallyRemoved: Boolean) = Props(classOf[BinaryTreeNode],  elem, initiallyRemoved)
}

class BinaryTreeNode(val elem: Int, initiallyRemoved: Boolean) extends Actor {
  import BinaryTreeNode._
  import BinaryTreeSet._

  var subtrees = Map[Position, ActorRef]()
  var removed = initiallyRemoved

  // optional
  def receive = normal

  // optional
  /** Handles `Operation` messages and `CopyTo` requests. */
  val normal: Receive = {
    case Insert(requester, id, e) => {
        if (elem == e) {
          removed = false
          requester ! OperationFinished(id)
        }
        else if (e < elem) subtrees.contains(Left) match {
          case true => subtrees(Left) ! Insert(requester, id, e)
          case false => {
            subtrees += (Left -> context.actorOf(BinaryTreeNode.props(e, false)))
            requester ! OperationFinished(id)
          }
        }
        else subtrees.contains(Right) match {
          case true => subtrees(Right) ! Insert(requester, id, e)
          case false => {
            subtrees += (Right -> context.actorOf(BinaryTreeNode.props(e, false)))
            requester ! OperationFinished(id)
          }
        }
    }
    case Contains(requester, id, e) => {
      if (elem == e) requester ! ContainsResult(id, !removed)
      else if (e < elem) subtrees.contains(Left) match {
        case true => subtrees(Left) ! Contains(requester, id, e)
        case false => requester ! ContainsResult(id, false)
      }
      else subtrees.contains(Right) match {
        case true => subtrees(Right) ! Contains(requester, id, e)
        case false => requester ! ContainsResult(id, false)
      }
    }
    case Remove(requester, id, e) => {
      if (e == elem) {
        removed = true
        requester ! OperationFinished(id)
      }
      else if (e < elem) subtrees.contains(Left) match {
        case true => subtrees(Left) ! Remove(requester, id, e)
        case false => requester ! OperationFinished(id)
      }
      else subtrees.contains(Right) match {
        case true => subtrees(Right) ! Remove(requester, id, e)
        case false => requester ! OperationFinished(id)
      }
    }
    case CopyTo(newRoot) => {
      if (removed && subtrees.isEmpty) {
        context.parent ! CopyFinished
        context.stop(self)
      }
      else {
        var expected = Set[ActorRef]()
        if (subtrees contains Left) expected += subtrees(Left)
        if (subtrees contains Right) expected += subtrees(Right)
        if (expected.isEmpty && removed) {          
          context.parent ! CopyFinished
          context.stop(self)                    
        }
        else if (removed) {
          context become copying(expected, true)
          subtrees.values foreach (_ ! CopyTo(newRoot))
        }
        else {
          context become copying(expected, false)
          newRoot ! Insert(self, 0, elem)
          subtrees.values foreach (_ ! CopyTo(newRoot))
        }
      }
    }
  }

  // optional
  /** `expected` is the set of ActorRefs whose replies we are waiting for,
    * `insertConfirmed` tracks whether the copy of this node to the new tree has been confirmed.
    */
  def copying(expected: Set[ActorRef], insertConfirmed: Boolean): Receive = {
    case OperationFinished(_) => {
      if (expected.isEmpty) {
        context.parent ! CopyFinished
        context.stop(self)
      }
      else {
        context become copying(expected, true)
      }
    }
    case CopyFinished => {
      val remains = expected - sender
      if (remains.isEmpty && insertConfirmed) {
        context.parent ! CopyFinished
        context.stop(self)
      }
      else context become copying(remains, insertConfirmed)
    }
  }


}
