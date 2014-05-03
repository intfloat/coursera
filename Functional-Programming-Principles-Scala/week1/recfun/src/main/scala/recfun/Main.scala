package recfun
import common._

object Main {
  def main(args: Array[String]) {
    println("Pascal's Triangle")
    for (row <- 0 to 10) {
      for (col <- 0 to row)
        print(pascal(col, row) + " ")
      println()
    }
  }

  /**
   * Exercise 1
   */
  def pascal(c: Int, r: Int): Int = 
    if (c == 0 || c == r) 1
    else pascal(c-1, r-1) + pascal(c, r-1)

  /**
   * Exercise 2
   */
  def balance(chars: List[Char]): Boolean = {
//      define a helper function to function like a stack
    def check(s: List[Char], openParen : Int): Boolean = {
      if(s.isEmpty) {
        openParen == 0
      } 
      else{
        if(s.head == '(') check(s.tail, openParen+1)
        else if(s.head == ')') {
          if (openParen == 0) false else check(s.tail, openParen-1)
        }
        else check(s.tail, openParen)
      }
    }
    check(chars, 0)
  }
    

  /**
   * Exercise 3
   */
  def countChange(money: Int, coins: List[Int]): Int = {
    if (money == 0) 1
    else if (coins.isEmpty) 0
    else if (money >= coins.head) countChange(money, coins.tail) + 
    		countChange(money-coins.head, coins)
    else countChange(money, coins.tail)
  } // end method countChange
  
  
} // end object Main
