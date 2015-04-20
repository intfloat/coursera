package simulations
package gui

import javax.swing.{JComponent, JFrame, JLabel, Timer, SwingUtilities}
import javax.swing.border.{EmptyBorder}
import java.awt.{Graphics, Graphics2D, GridLayout, BorderLayout, Color, Dimension, Rectangle, Polygon}
import java.awt.event.{ActionListener, ActionEvent}

object EpidemyDisplay extends EpidemySimulator with App {

  class Situation(var healthy: Int, var sick: Int, var immune: Int) {
    def reset { healthy = 0; sick = 0; immune = 0 }
    def count(p: Person) {
      if (p.immune) immune += 1
      else if (p.sick) sick += 1
      else healthy += 1
    }
    override def toString() = "Situation(" + healthy + ", " + sick + ", " + immune + ")"
  }

  val world: Grid[Situation] = new Grid[Situation](SimConfig.roomRows, SimConfig.roomColumns)
  for (row <- 0 to world.height - 1; col <- 0 to world.width - 1)
    world.update(row, col, new Situation(0, 0, 0))
  var history: List[Situation] = Nil
  var historyContinues = true

  def updateWorld() {
    for (p <- persons) world(p.row, p.col) count p
  }
  updateWorld()

  def updateHistory() {
    historyContinues = history.isEmpty
    for (p <- persons) {
      historyContinues = historyContinues || p.infected
    }
    val ns = new Situation(0, 0, 0)
    for (s <- world) {
      ns.healthy += s.healthy
      ns.sick += s.sick
      ns.immune += s.immune
    }
    history = ns :: history
  }

  def hasStep: Boolean = !agenda.isEmpty

  private object GraphicConfig {
    val delay = 200
    val personSize = 8
    val interPersonSize = 4
    val roomBorderSize = 4
    val interRoomSize = 4
    val worldBorderSize = 12
    val doorSize = 12
    val lineCount = 4
    def roomSize = (lineCount * personSize) + ((lineCount - 1) * interPersonSize) + (2 * roomBorderSize) + 2
    def totalCount = lineCount * lineCount
    def doorWallSize = (roomSize - doorSize) / 2
  }

  import GraphicConfig._

  class Room (val worldRow: Int, val worldCol: Int) extends JComponent {
    val roomDimension = new Dimension(roomSize + 1, roomSize + 1)
    setPreferredSize(roomDimension)
    var situation: Situation = null
    def sick = situation.sick min totalCount
    def healthy = (sick + situation.healthy) min totalCount
    def immune = (healthy + situation.immune) min totalCount
    override def paintComponent(g: Graphics) {
      val graph = g.asInstanceOf[Graphics2D]
      graph.setColor(Color.WHITE)
      graph.drawPolyline(Array(0, 0, doorWallSize), Array(doorWallSize, 0, 0), 3)
      graph.drawPolyline(Array(doorWallSize + doorSize, roomSize, roomSize), Array(0, 0, doorWallSize), 3)
      graph.drawPolyline(Array(roomSize, roomSize, doorWallSize + doorSize), Array(doorWallSize + doorSize, roomSize, roomSize), 3)
      graph.drawPolyline(Array(doorWallSize, 0, 0), Array(roomSize, roomSize, doorWallSize + doorSize), 3)
      for (row <- 0 until lineCount; col <- 0 until lineCount) {
        def color(state: Int) = (state / lineCount) > row || ((state / lineCount) == row && (state % lineCount) > col)
        if (color(sick)) graph.setColor(Color.RED)
        else if (color(healthy)) graph.setColor(Color.GREEN)
        else if (color(immune)) graph.setColor(Color.YELLOW)
        else graph.setColor(Color.DARK_GRAY)
        graph.drawOval(roomBorderSize + 1 + (col * (personSize + interPersonSize)), roomBorderSize + 1 + (row * (personSize + interPersonSize)), personSize, personSize)
      }
    }
    def setSituation(s: Situation): this.type = {
      situation = s
      this
    }
  }

  val frame = new JFrame("Scaliosis") { frame =>
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
    setBackground(Color.BLACK)
    val rooms: Grid[Room] = new Grid[Room](world.height, world.width)
    object populationGraph extends JComponent {
      val graphHeight = 100
      setPreferredSize(new Dimension(getWidth, graphHeight))
      override def paintComponent(g: Graphics) {
        val graph = g.asInstanceOf[Graphics2D]
        if (history.isEmpty) {
          graph.setColor(Color.DARK_GRAY)
          graph.fill(new Rectangle(getWidth, graphHeight))
        }
        else {
          val steps: Double = history.length - 1
          val advanceStep: Double = (((getWidth - 3).toDouble) / (steps + 1)).toDouble
          def proportion(count: Int): Int =
            getHeight - ((getHeight - 3) * (count.toDouble / SimConfig.population.toDouble)).toInt - 2
          def advance(index: Int): Int =
            getWidth - (advanceStep * ((index + 1.0))).toInt
          val sickPoly = new Polygon()
          val immunePoly = new Polygon()
          var prevStep = -1
          for ((s, i) <- history zip history.indices) {
            val sick = proportion(s.sick)
            val immune = proportion(s.sick + s.immune)
            val step = advance(i) - 2
            if (prevStep != step) {
              sickPoly.addPoint(step, sick)
              immunePoly.addPoint(step, immune)
            }
            prevStep = step
          }
          sickPoly.addPoint(1, getHeight - 2)
          sickPoly.addPoint(getWidth - 2, getHeight - 2)
          sickPoly.addPoint(getWidth - 2, proportion(history.head.sick))
          immunePoly.addPoint(1, getHeight - 2)
          immunePoly.addPoint(getWidth - 2, getHeight - 2)
          immunePoly.addPoint(getWidth - 2, proportion(history.head.sick + history.head.immune))
          graph.setColor(Color.GREEN)
          graph.fill(new Rectangle(getWidth, graphHeight))
          graph.setColor(Color.YELLOW)
          graph.fillPolygon(immunePoly)
          graph.setColor(Color.RED)
          graph.fillPolygon(sickPoly)
        }
        graph.setColor(Color.WHITE)
        graph.drawRect(0, 0, getWidth -1, graphHeight - 1)
      }
    }
    object roomDisplay extends JComponent {
      setLayout(new GridLayout(world.width, world.height, interRoomSize, interRoomSize))
      setBorder(new EmptyBorder(worldBorderSize, 0, worldBorderSize, 0))
      for (row <- 0 until world.height; col <- 0 until world.width) {
        val room = (new Room(row, col)) setSituation world(row, col)
        rooms.update(row, col, room)
        add(room)
      }
    }
    object clock extends JLabel with ActionListener {
      val time = new Timer(delay, this)
      def start = time.start
      setBackground(Color.BLACK)
      setForeground(Color.WHITE)
      setOpaque(true)
      setText("Starting...")
      var countTime = 0
      def actionPerformed(event: ActionEvent) {
        if (currentTime <= countTime) {
          assert(hasStep)
          for (w <- world) w.reset
          updateWorld()
          if (historyContinues) updateHistory()
          frame.repaint()
          next
          val previousTime = currentTime
          while (!agenda.isEmpty && agenda.head.time == previousTime) next
        } else if (historyContinues && !history.isEmpty) {
          history = history.head :: history
        }
        if (!history.isEmpty) setText("On day " + countTime + ", " +
                                      history.head.healthy + " healthy, " +
                                      history.head.sick + " sick/dead, " +
                                      history.head.immune + " immune.")
        populationGraph.repaint()
      	countTime += 1
        if (countTime == 150) println("Dead people on day 150: "+persons.count(p => p.dead))
      }
    }
    setContentPane(new JComponent {
      setBorder(new EmptyBorder(worldBorderSize, worldBorderSize, worldBorderSize, worldBorderSize))
      setLayout(new BorderLayout)
      add(populationGraph, BorderLayout.SOUTH)
      add(roomDisplay, BorderLayout.CENTER)
      add(clock, BorderLayout.NORTH)
    })
    pack
    setResizable(false)
    setVisible(true)
    println("Scaliosis is ready to spread")
    clock.start
    override def paint(g: Graphics) {
      for (room <- rooms)
        room setSituation world(room.worldRow, room.worldCol)
      super.paint(g)
    }
  }

}
