package quickcheck

import common._

import org.scalacheck._
import Arbitrary._
import Gen._
import Prop._

abstract class QuickCheckHeap extends Properties("Heap") with IntHeap {

  property("min1") = forAll { a: Int =>    
    val h = insert(a, empty)
    findMin(h) == a
  }
  
  property("min2") = forAll { (a:Int, b: Int) =>     
     val h1 = insert(a, empty)
     val h2 = insert(b, h1)
     findMin(meld(h1, h2)) == Math.min(a, b)
  }
  
  property("deleteMin") = forAll { (a: Int, b: Int, c: Int) =>
    val h = insert(a, empty)
    val h1 = insert(b, h)
    val h2 = deleteMin(h1)
    val h3 = deleteMin(meld(insert(c, empty), h1))
    val h4 = deleteMin(h3)
    findMin(h2) == Math.max(a, b) && findMin(h4) == Math.max(a, Math.max(b, c))
  }

  lazy val genHeap: Gen[H] = ???

  implicit lazy val arbHeap: Arbitrary[H] = Arbitrary(genHeap)

}
