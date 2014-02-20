-- this is for week 8 View programming exercises

-- problem 1 in core set
create trigger R1
instead of update of title on LateRating
for each row
begin
    update Movie
    set title = New.title
    where title = Old.title
    and New.mID = Old.mID;
end;

drop trigger R1;

-- problem 2 in core set
create trigger R2
instead of update of stars on LateRating
for each row
begin
    update Rating
    set stars = New.stars
    where Old.ratingDate = New.ratingDate
    and Old.mID = New.mID
    and New.mID = Rating.mID
    and New.ratingDate = Rating.ratingDate;
end;

drop trigger R2;

-- problem 3 in core set

create trigger R3
instead of update of mID on LateRating
for each row
begin
    update Rating
    set mID = New.mID
    where mID = Old.mID;    

    update Movie
    set mID = New.mID
    where mID = Old.mID;
end;

drop trigger R3;

-- problem 4 in core set
create trigger R4
instead of delete on HighlyRated
for each row
begin
    delete from Rating
    where mID = Old.mID
    and stars > 3;
end;

drop trigger R4;

-- problem 5 in core set
create trigger R5
instead of delete on HighlyRated
for each row
begin
    update Rating
    set stars = 3
    where mID = Old.mID
    and stars > 3;
end;

drop trigger R5;

-- problem 1 in challenge set
create trigger R6
instead of update on LateRating
for each row
when New.ratingDate = Old.ratingDate
begin
    update Movie
    set mID = New.mID, title = New.title
    where mID = Old.mID;

    update Rating
    set mID = New.mID
    where mID = Old.mID;

    update Rating
    set stars = New.stars
    where mID = New.mID
    and ratingDate = Old.ratingDate
    and ratingDate > '2011-01-20';

end;

drop trigger R6;

-- problem 2 in challenge set
create trigger R7
instead of insert on HighlyRated
for each row
when exists (select mID from Movie where mID = New.mID and title = New.title)
begin
    insert into Rating values(201, New.mID, New.title, 5, NULL);
end;

drop trigger R7;

-- problem 3 in challenge level set
create trigger R8
instead of insert on NoRating
for each row
-- check if it is in Movie table
when exists (select mID from Movie where mID=New.mID and title=New.title)
begin
    delete from Rating
    where mID = New.mID;
end;

drop trigger R8;

