package simulations
package gui

import language.implicitConversions
import scala.reflect.ClassTag

class Grid[A: ClassTag](val height: Int, val width: Int) extends Function2[Int,Int, A] with Iterable[A] {
  
  private val delegate = new Array[A](height * width)
  
  override def apply(row: Int, col: Int): A =
    delegate(row % height * width + col % width)
  
  def update(row: Int, col: Int, elem: A) {
    delegate(row % height * width + col % width) = elem
  }
  
  override def size: Int = height * width
  
  def iterator: Iterator[A] = delegate.iterator
  
}

object Grid {
  
  private class SubArray[A](delegate: Array[A], start: Int, val length: Int) extends Seq[A] {
    def iterator = delegate.iterator.drop(start).take(length)
    def apply(index: Int): A = delegate(index - start)
  }
  
  implicit def gridToSeqs[A](grid: Grid[A]): Seq[Seq[A]] = {
    val result = new Array[SubArray[A]](grid.height)
    for (row <- 0 to grid.height - 1)
      result(row) = new SubArray[A](grid.delegate, row * grid.width, grid.width)
    result
  }
  
  
  implicit def seqsToGrid[A: ClassTag](lists: Seq[Seq[A]]): Grid[A] = {
    Console.println("Convertir une liste de sequences en une grille est tres inefficace!")
    val listsList: List[Seq[A]] = lists.toList
    val result = new Grid[A](lists.length, if (lists.length > 0) lists(0).length else 0)
    for ((ls, row) <- listsList zip listsList.indices; (l, col) <- ls.toList zip ls.toList.indices) 
      result.update(row, col, l)
    result
  }
  
  
}
