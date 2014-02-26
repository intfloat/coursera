
-- this is for Question 1 in core set 
create trigger R1
after insert on Highschooler
for each row
when New.name = 'Friendly'
begin
    insert into Likes 
    select New.ID, Highschooler.ID
    from Highschooler
    where New.grade = Highschooler.grade and
     New.ID != Highschooler.ID;
end;

drop trigger R1;

-- this is for Question 2 in core set
create trigger R2
after insert on Highschooler
for each row
when New.grade<9 or New.grade>12
begin
    update Highschooler set grade = null
    where Highschooler.ID = New.ID;
end
|
create trigger R3
after insert on Highschooler
for each row
when New.grade is null
begin
    update Highschooler set grade = 9
    where Highschooler.ID = New.ID;
end;

drop trigger R2;
drop trigger R3;

-- this is for Question 3 in core set
create trigger R4
after update of grade on Highschooler
for each row
when New.grade > 12
begin
    delete from Highschooler
    where Highschooler.grade > 12;
end;

drop trigger R4;

-- this is for Question 1 in challenge level
create trigger R5
after delete on Friend
for each row
begin
    delete from Friend
    where Old.ID1 = Friend.ID2 and Old.ID2 = Friend.ID1;
end
|
create trigger R6
after insert on Friend
for each row
begin
    insert into Friend values(New.ID2, New.ID1);
end;

drop trigger R5;
drop trigger R6;

-- this is for Question 2 in challenge level
create trigger R7
after update of grade on Highschooler
for each row
when New.grade > 12
begin
    delete from Highschooler 
    where New.ID = Highschooler.ID;
end
|
create trigger R8
after update of grade on Highschooler
for each row
begin
    update Highschooler set grade = grade+1
    where Highschooler.ID in (select ID2 from Friend
        where New.ID=ID1 and New.ID<>ID2);
end;

drop trigger R7;
drop trigger R8;

-- this is for Question 3 in challenge level
create trigger R9
after update on Likes
for each row
when New.ID1=Old.ID1 and New.ID2<>Old.ID2
begin
    delete from Friend
    where (Friend.ID1=Old.ID2 and Friend.ID2=New.ID2)
       or (Friend.ID1=New.ID2 and Friend.ID2=Old.ID2);
end;

drop trigger R9;
