(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* this is a helper function to check whether a string is in given list*)
fun is_in_list(s : string, arr : string list) =
  case arr of
       [] => false
     | first::arr' => (same_string(s, first)) orelse is_in_list(s, arr')

(* this is a helper function to get a list without given string*)
fun remove_string(s : string, arr : string list) =
  case arr of
       [] => []
     | first::arr' => if same_string(first, s)=true
            then remove_string(s, arr') 
            else first::remove_string(s, arr')                        
                        
(* first check if given string is in list, then handle each case*)
fun all_except_option(s : string, arr : string list) =
    let val is_in = is_in_list(s, arr)
    in if is_in=true 
            then let val result=remove_string(s, arr) in SOME result end
            else NONE
     end


(* if arr is empty, then return empty list; else take advantage of
    all_except_option() function to get final result  *)
fun get_substitutions1(arr : string list list, sub : string) =
  case arr of
       [] => []
     | first::arr' => let val result=all_except_option(sub, first) 
                      in case result of 
                              SOME res => res @ (get_substitutions1(arr', sub))
                            | NONE => get_substitutions1(arr', sub)
                      end
                     

(* implement similar function using tail recursion technique*)
fun get_substitutions2(arr : string list list, sub : string) =
    let fun aux(arr, sub, res) =
            case arr of
                 [] => res
               | first::arr' => let val tmp = all_except_option(sub, first)
                                in case tmp of
                                        SOME t => aux(arr', sub, res @ t)
                                      | NONE => aux(arr', sub, res)
                                end
    in aux(arr, sub, [])
    end

(* get string list using get_substitutions1() function, then get record list *)
fun similar_names(arr : string list list, 
  r: {first:string, middle:string,  last:string}) =
  let val {first=x, middle=y, last=z}  = r
  in
     let val names = get_substitutions1(arr, x)
         (* this is a nested helper function to get record list *)
         fun get_result(arr : string list) =
             case arr of
                 [] => []
               | head::arr' => {first=head, middle=y, last=z}::get_result(arr')
     in r::get_result(names)
     end
  end



(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(* one case expression is enough *)
fun card_color(c : card) =
  case c of
       (Clubs, _) => Black
     | (Spades, _) => Black
     | _ => Red


(* just check the value of rank *)
fun card_value(c : card) =
  case c of
       (_, Num(i)) => i
     | (_, Ace) => 11
     | _ => 10


(* if find given card, return all remaining elements in the list *)
fun remove_card(cs : card list, c : card, e : exn) =
  case cs of
       [] => raise e
     | head::cs' => if head=c then cs' else remove_card(cs', c, e)


(* refer to professor's notes about nested patterns *)
fun all_same_color(cs : card list) =
  case cs of
       [] => true
     | head::[] => true
     | head::(neck::rest) => (card_color(head)=card_color(neck) 
                             andalso all_same_color(neck::rest))



(* compute sum of all card values using tail recursion *)
fun sum_cards(cs : card list) =
  let fun mysum(cs : card list, res : int) =
          case cs of
               [] => res
             | head::cs' => mysum(cs', res+card_value(head))
  in mysum(cs, 0)
  end
 (* case cs of
       [] => 0
     | head::cs' => card_value(head)+sum_cards(cs')
  *)


(* compute score of current cards according to given instructions. *)
fun score(cs : card list, goal : int) =
    let val sum = sum_cards(cs)
        val same = all_same_color(cs)
        val pre = if sum>goal then 3*(sum-goal) else (goal-sum)
    in
      if same=true then (pre div 2) else pre
    end


(* take a list of cards and moves, return corresponding score. *)
fun officiate(cs1 : card list, ms1 : move list, goal : int) =
  (* this is a help function to simulate whole process*)
  let fun simulate(cs : card list, ms : move list, hl : card list, goal : int) =
        if sum_cards(hl)>goal then score(hl, goal)
        else case ms of
                [] => score(hl, goal)
               | m::ms' => (case m of
                                Draw => (case cs of
                                             [] => score(hl, goal)
                                           | head::cs' => simulate(cs', ms', 
                                                            head::hl, goal))
                              | Discard(c) => simulate(cs, ms', 
                                              remove_card(hl, c, IllegalMove), goal))
  in simulate(cs1, ms1, [], goal)
  end
