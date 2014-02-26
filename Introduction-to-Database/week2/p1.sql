/*Question 1*/
select title
from Movie
where director="Steven Spielberg"

/*Question 2*/
select distinct year
from Movie, Rating
where Movie.mID=Rating.mID and stars>=4
order by year

/*Question 3*/
select title
from Movie
where Movie.title not in (select title from Movie, Rating where Movie.mID=Rating.mID)

/*Question 4*/
select Reviewer.name
from Rating, Reviewer
where Rating.rID=Reviewer.rID and ratingDate is null

/*Question 5*/
select name, title, stars, ratingDate
from Movie, Reviewer, Rating
where Movie.mID=Rating.mID and Reviewer.rID=Rating.rID
order by name, title, stars

