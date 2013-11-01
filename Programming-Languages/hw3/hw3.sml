(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

fun only_capitals strs =
  List.filter (fn str => Char.isUpper(String.sub(str, 0))) strs

fun longest_string1 strs =
  List.foldl (fn (str, cur) => if (String.size(str) > String.size(cur)) then str else cur)  "" strs

fun longest_string2 strs =
  List.foldl (fn (str, cur) => if (String.size(str) >= String.size(cur)) then str else cur)  "" strs

fun longest_string_helper f strs =
  case strs of
       [] => ""
     | head::strs' => let val ans = longest_string_helper f strs'
                      in if f(String.size(ans), String.size(head))
                         then ans
                         else head
                      end

fun longest_string3 strs = longest_string_helper (fn (n1, n2) => n1 > n2 ) strs

fun longest_string4 strs= longest_string_helper (fn (n1, n2) => n1 >= n2) strs


fun longest_capitalized strs =
  case strs of
       [] => ""
     | str::strs' => let val cap = fn(str) => if Char.isUpper(String.sub(str, 0)) then str else ""
                         val longer = fn(str1, str2) => if String.size(str1)>String.size(str2) then str1 else str2
                     in
                       longer(longest_capitalized strs', cap(str))
                     end

fun rev_string str =
  (String.implode o List.rev o String.explode)str

fun first_answer f arr =
  case arr of
       [] => raise NoAnswer
     | head::arr' => case f head of
                          NONE => first_answer f arr'
                        | SOME ans => ans

fun all_answers f arr =
      case arr of
         [] => SOME []
       | head::arr' => (case f head of
                        NONE => NONE
                      | SOME ans => let val nex = all_answers f arr'
                                    in (case nex of
                                            NONE => NONE
                                          | SOME nexl => SOME (ans@nexl))
                                    end
                       )

fun count_wildcards pat =
    case pat of
       Wildcard => 1
     | TupleP patl => (case patl of
                           [] => 0
                         | head::patl' => 
                             count_wildcards head + count_wildcards (TupleP patl'))
     | ConstructorP (str, pat') => count_wildcards pat'
     | _ => 0


fun count_wild_and_variable_lengths pat =
    let val wild = count_wildcards pat
        fun count_lengths pat = 
                        case pat of
                             Variable str => String.size(str)
                           | TupleP patl => (case patl of
                                                [] => 0
                                              | head::patl' =>
                                                count_lengths(head) +
                                                count_lengths(TupleP patl'))
                           | ConstructorP (str, pat') => count_lengths pat'
                           | _ => 0
    in wild + count_lengths pat
    end

fun count_some_var (str, pat) =
  case pat of
       Variable s => if str=s then 1 else 0
     | TupleP patl => (case patl of
                            [] => 0
                          | head::patl' =>
                              count_some_var(str, head) +
                              count_some_var(str, TupleP patl'))
     | ConstructorP (s, pat') => count_some_var(str, pat')
     | _ => 0

fun check_pat pat =
    (* helper function to get list of strings *)
    let fun get_all pat =
        case pat of
             Variable s => [s]
           | TupleP patl => (case patl of
                                  [] => []
                                | head::patl' =>
                                    get_all(head) @ get_all(TupleP patl'))
           | ConstructorP (s, pat') => get_all(pat')
           | _ => []
        (* helper function to check if strings are unique *)
        fun unique strs =
          case strs of
               [] => true
             | head::strs' => if count_some_var(head, pat)=1 
                              then unique strs' 
                              else false
    in
      (unique o get_all) pat
    end

fun match (valu, pat) =
  (* deal with 7 cases separately *)
  case (pat, valu) of
       (Wildcard, _) => SOME []
     | (Variable s, _) => SOME [(s, valu)]
     | (UnitP, Unit) => SOME []
     | (ConstP n1, Const n2) => if n1=n2 then SOME [] else NONE
     | (TupleP p, Tuple v) => if List.length(p)=List.length(v)
                              then let val zip = ListPair.zip(v, p)
                                   in all_answers match zip
                                   end
                              else NONE
     | (ConstructorP(s1, p), Constructor(s2, v)) => 
         if s1 = s2
         then match (v, p)
         else NONE
     | _ => NONE

fun first_match valu pl =
  case pl of
       [] => NONE
     | head::pl' => case match(valu, head) of
                         NONE => first_match valu pl'
                       | SOME ans => SOME ans

