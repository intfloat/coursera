fun foo f x y z =
  if x >= y
  then (f z)
  else foo f y x (tl z)
fun baz f a b c d e = (f (a^b))  ::(c+d)::e
signature DIGIT = 
sig
  type digit
  val make_digit : int -> digit
  val increment : digit -> digit
  val decrement : digit -> digit
  val down_and_up : digit -> digit
  val test : digit -> unit
end

fun mystery f xs =
    let
        fun g xs =
           case xs of
             [] => NONE
           | x::xs' => if f x then SOME x else g xs'
    in
	case xs of
            [] => NONE
	  | x::xs' => if f x then g xs' else mystery f xs'
    end


structure Digit :> DIGIT =
struct
  type digit = int
  exception BadDigit
  exception FailTest
  fun make_digit i = if i < 0 orelse i > 9 then raise BadDigit else i
  fun increment d = if d=9 then 0 else d+1
  fun decrement d = if d=0 then 9 else d-1
  val down_and_up = increment o decrement (* recall o is function composition *)
  fun test d = if down_and_up d = d then () else raise FailTest
end

signature COUNTER =
sig
    type t = int
    val newCounter : int -> t
    val first_larger : t * t -> bool
end



structure NoNegativeCounter :> COUNTER = 
struct

exception InvariantViolated

type t = int

fun newCounter i = if i <= 0 then 1 else i

fun increment i = i + 1

fun first_larger (i1,i2) =
    if i1 <= 0 orelse i2 <= 0
    then raise InvariantViolated
    else (i1 - i2) > 0

end

