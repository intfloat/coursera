
-- Coursera Course: Introduction to Database

-- this is for Question 6
--select name, title
--from Movie, Reviewer, (select r1.rID, r1.mID
--from Rating r1, Rating r2
--where r1.rID = r2.rID 
--and r1.mID = r2.mID
--and r1.ratingDate < r2.ratingDate
--and r1.stars < r2.stars) Record
--where Movie.mID = Record.mID
--and Reviewer.rID = Record.rID;

-- this is for Question 7
--select title, stars
--from Movie, (select mID, stars
--from Rating
--except
--select r1.mID, r1.stars
--from Rating r1, Rating r2
--where r1.mID = r2.mID
--and r1.stars < r2.stars) Record
--where Movie.mID = Record.mID
--order by title;

-- this is for Question 8
--select title, spread
--from Movie, (select mID, max(stars)-min(stars) as spread
--            from Rating
--            group by mID) Record
--where Movie.mID = Record.mID
--order by spread DESC, title;

-- this is for Question 9
--select avg(R1.avg_star)-avg(R2.avg_star)
--from (select Rating.mID, avg(stars) as avg_star
--    from Movie, Rating
--    where Movie.mID = Rating.mID
--    and Movie.year < 1980
--    group by Movie.mID) R1,
--    (select Rating.mID, avg(stars) as avg_star
--    from Movie, Rating
--    where Movie.mID = Rating.mID
--    and Movie.year > 1980
--    group by Movie.mID) R2;

-- this is for Stanford Online Question 8
--select title, avg_star
--from Movie, (select mID, avg(stars) as avg_star
--    from Rating
--    group by mID) Record
--where Movie.mID = Record.mID
--order by avg_star DESC, title;

-- this is for Stanford Online Question 9
--select name
--from Reviewer, (select rID, count(rID) as num
--    from Rating
--    group by rID) Record
--where Reviewer.rID = Record.rID
--and num > 2;

-- this is for Stanford Online Question 3
--select title, Record.director
--from Movie, (select director, count(director) as num
--    from Movie
--    group by director) Record
--where Movie.director = Record.director
--and num > 1
--order by Record.director, title;

-- this is for Stanford Online Question 4
--select title, mRating
--from Movie, (select max(avg_star) as mRating
--    from (select mID, avg(stars) as avg_star
--        from Rating
--        group by mID)) R1,
--    (select mID, avg(stars) as avg_star
--    from Rating
--    group by mID) R2
--where Movie.mID = R2.mID
--and R2.avg_star = R1.mRating;

-- this is for Stanford Online Question 6

--select distinct Record.director, title, Record.mStar
--from Movie, Rating, (select director, max(stars) as mStar
--    from Movie, Rating
--    where Movie.mID = Rating.mID
--    and Movie.director is not NULL
--    group by director) Record
--where Movie.mID = Rating.mID
--    and Movie.director is not NULL
--    and Movie.director = Record.director
--    and Rating.stars = Record.mStar;


-- Modification set Question 2
--insert into Rating
--select Reviewer.rID, Movie.mID, 5 as stars, null as ratingDate
--from Movie, Reviewer
--where Reviewer.name = 'James Cameron';

-- Modification set Question 3
--update Movie
--set year = year+25
--where mID in (select mID 
--            from (select mID, avg(stars) as num
--                from Rating            
--                group by mID) 
--            where num >= 4);

-- Modification set Question 4
--delete from Rating
--where mID in ( select Movie.mID
--    from Movie, Rating
--    where Movie.mID = Rating.mID
--    and ( (Movie.year > 2000) or (Movie.year < 1970) ) )
--and stars < 4;

-- Social Network Question 1

--select h1.name
--from Highschooler h1, Friend, Highschooler h2
--where Friend.ID1 = h1.ID
--and Friend.ID2 = h2.ID
--and h2.name = "Gabriel";

-- Social Network Question 2
--select h1.name, h1.grade, h2.name, h2.grade
--from Highschooler h1, Likes, Highschooler h2
--where h1.ID = Likes.ID1
--and h2.ID = Likes.ID2
--and h1.grade > h2.grade+1;

-- Social Network Question 3
--select h1.name, h1.grade, h2.name, h2.grade
--from Highschooler h1, Highschooler h2, Likes L1, Likes L2
--where h1.name < h2.name
--    and L1.ID1 = L2.ID2
--    and L1.ID2 = L2.ID1
--    and h1.ID = L1.ID1
--    and h2.ID = L1.ID2;

-- Social Network Question 4
--select name, grade
--from Highschooler, ( select ID1 from Friend
--      except
--      select h1.ID 
--      from Highschooler h1, Highschooler h2, Friend
--      where Friend.ID1 = h1.ID
--      and Friend.ID2 = h2.ID
--      and h1.grade <> h2.grade ) Record
--where Record.ID1 = Highschooler.ID
--order by grade, name;


-- Social Network Question 5
--select name, grade
--from Highschooler, (select ID2
--    from (select ID2, count(ID2) as num
--        from Likes
--        group by ID2)
--    where num > 1) Record
--where Highschooler.ID = Record.ID2;

--delete from Highschooler
--where grade = 12;

-- Social Network Modification Question 2
--delete from Likes
--where ID1 in ( select Likes.ID1
--    from Friend, Likes
--    where Likes.ID1 = Friend.ID1
--    and Likes.ID2 = Friend.ID2
--    except
--    select L1.ID1
--    from Likes L1, Likes L2
--    where L1.ID1 = L2.ID2
--    and L1.ID2 = L2.ID1 )


-- Social Network Modification Question 3
-- insert new element into existing Friend relationship
--insert into Friend
--select F1.ID1, F2.ID2
--from Friend F1, Friend F2
--where F1.ID2 = F2.ID1
-- nonsese to establish friendship within itself
--and F1.ID1 <> F2.ID2
-- should not already existing relationship
--except select * from Friend

-- Social Network Challenge Level Question 1
--select name, grade
--from Highschooler h
--where h.ID not in (select ID1 from Likes
--      union select ID2 from Likes)
--order by grade, name;


-- Social Network Challenge Level Question 2
--select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
--from Highschooler h1, Highschooler h2, Highschooler h3,
-- three student IDs that satisfies given requirement
--(select F3.ID1 as s1, F3.ID2 as s2, F1.ID1 as s3
--from Friend F1, Friend F2,
-- student who one likes another but they are not friends
--(select ID1, ID2
--from Likes except select * from Friend) F3
--where F1.ID1 = F2.ID1
--    and F1.ID2 = F3.ID1
--    and F2.ID2 = F3.ID2) R
--where R.s1 = h1.ID
--    and R.s2 = h2.ID
--    and R.s3 = h3.ID;


-- Social Network Challenge Level Question 3
--select count(ID) - count(distinct name)
--from Highschooler;

-- Social Network Challenge Level Question 4
-- compute average number of friends per student
--select avg(avg_fri)
--from (select count(ID2) as avg_fri
--    from Friend
--    group by ID1);

-- Social Network Challenge Level Question 5
select count(s)
from
-- a direct friend with Cassandra
( select f.ID2 as s from Friend f, Highschooler h
where h.name = "Cassandra"
    and f.ID1 = h.ID
union
-- an indirect friend with Cassandra
select f1.ID1 as s
from Friend f1, Friend f2, Highschooler h
where f1.ID2 = f2.ID1
    and h.ID = f2.ID2
    and h.name = "Cassandra"
except
select ID as s from Highschooler
where name = "Cassandra" 
);


-- Question 5
-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
select count(distinct F1.ID2) + count(distinct F2.ID2)
from Friend F1, Friend F2, Highschooler
where Highschooler.name = 'Cassandra'
and Highschooler.ID = F1.ID1
-- reach friends of friends
and F2.ID1 = F1.ID2
-- except herself
and F2.ID1 <> Highschooler.ID
and F2.ID2 <> Highschooler.ID
;


-- Question 6
-- Find the name and grade of the student(s) with the greatest number of friends.
select name, grade
from Highschooler, (
  select ID1 from Friend
  except
  -- student who has someone with more friends than them
  select distinct (FC1.ID1)
  from (
    select ID1, count(ID2) as FriendCount
    from Friend
    group by ID1
  ) as FC1,
  (
    select ID1, count(ID2) as FriendCount
    from Friend
    group by ID1
  ) as FC2
  where FC1.FriendCount < FC2.FriendCount
) as MaxFriend
where MaxFriend.ID1 = Highschooler.ID
;

