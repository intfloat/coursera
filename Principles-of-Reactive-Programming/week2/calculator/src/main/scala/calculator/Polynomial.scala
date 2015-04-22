package calculator

object Polynomial {
  def computeDelta(a: Signal[Double], b: Signal[Double],
      c: Signal[Double]): Signal[Double] = {
    Signal(b() * b() - 4 * a() * c())
  }

  def computeSolutions(a: Signal[Double], b: Signal[Double],
      c: Signal[Double], delta: Signal[Double]): Signal[Set[Double]] = {
    Signal {if (delta() < 0) Set()
    else if (a() == 0 && b() != 0) Set(-c() / b())
    else if (a() == 0 && b() == 0) Set() // actually infinite number of solutions
    else if (delta() == 0) Set(-b() / (2 * a()))
    else {
      val sol1 = (-b() + Math.sqrt(delta())) / (2 * a())
      val sol2 = (-b() - Math.sqrt(delta())) / (2 * a())
      Set(sol1, sol2)
    }}
  }
}
