
fun is_older(first : int*int*int, second : int*int*int) =
  if #1 (first) < #1 (second) then true
  else if #1(first) > #1(second) then false
  else if #2(first) < #2(second) then true
  else if #2(first) > #2(second) then false
  else if #3(first) < #3(second) then true
  else false


fun number_in_month(dates : (int*int*int) list, month : int) =
  if null dates then 0
  else 
    let val current = if #2(hd dates) = month then 1 else 0
    in current + number_in_month(tl dates, month)
    end

fun number_in_months(dates : (int*int*int) list, months : int list) =
  if null months then 0
  else number_in_month(dates, hd months) + number_in_months(dates, tl months)


fun dates_in_month(dates : (int*int*int) list, month : int) =
  if null dates then []
  else let val current = if #2(hd dates) = month then [hd dates] else []
       in 
         if null current then dates_in_month(tl dates, month)
         else (hd current) :: dates_in_month(tl dates, month)
       end


fun append(xs : (int*int*int) list, ys : (int*int*int) list) =
  if null xs then ys
  else hd(xs) :: append(tl(xs), ys)

fun dates_in_months(dates : (int*int*int) list, months : int list) =
  if null months then []
  else let val current = dates_in_month(dates, hd months)
       in append(current, dates_in_months(dates, tl months))
       end


fun get_nth(words : string list, n : int) =
  if n = 1 then hd words
  else get_nth(tl words, n-1)


(* define a list of words in convenience for searching *)
val date_words = ["January", "February", "March", "April","May", "June", "July",
"August", "September", "October", "November", "December"]

fun date_to_string(date : int*int*int) =
  get_nth(date_words, #2(date))^" "^Int.toString(#3(date))^", "^Int.toString(#1(date))


fun number_before_reaching_sum(sum : int, numbers : int list) =
  if sum <= hd numbers then 0
  else 1+number_before_reaching_sum(sum-(hd numbers), tl numbers)


val days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

fun what_month(day : int) =
  1+number_before_reaching_sum(day, days_in_month)

fun month_range(first : int, second : int) =
  if first > second then []
  else what_month(first) :: month_range(first+1, second)


fun oldest(dates : (int*int*int) list) =
  if null dates then NONE
  else let val remain = oldest(tl dates)
       in if isSome remain andalso is_older(valOf remain, hd dates)=true
          then remain
          else SOME(hd dates)
       end

