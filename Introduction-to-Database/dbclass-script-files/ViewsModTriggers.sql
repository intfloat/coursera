/**************************************************************
  VIEW MODIFICATIONS USING TRIGGERS
  Works for SQLite
  Postgres uses different rule/trigger syntax
  MySQL doesn't support rule-based view modifications
**************************************************************/

/**************************************************************
  DELETIONS FROM SIMPLE SINGLE-TABLE VIEW
**************************************************************/

create view CSaccept as
select sID, cName
from Apply
where major = 'CS' and decision = 'Y';

select * from CSaccept;
select * from Apply;

delete from CSaccept where sID = 123;

create trigger CSacceptDelete
instead of delete on CSaccept
for each row
begin
  delete from Apply
  where sID = Old.sID
  and cName = Old.cName
  and major = 'CS' and decision = 'Y';
end;

delete from CSaccept where sID = 123;

select * from CSaccept;
select * from Apply;

/**************************************************************
  INCORRECT TRANSLATION FOR UPDATES
**************************************************************/

select * from CSaccept;

update CSaccept set cName = 'CMU' where sID = 345;

create trigger CSacceptUpdate
instead of update of cName on CSaccept
for each row
begin
  update Apply
  set cName = New.cName
  where sID = Old.sID
  and cName = Old.cName
  and major='EE' and decision='N';
end;

update CSaccept set cName = 'CMU' where sID = 345;

select * from CSaccept;
select * from Apply;

/**************************************************************
  INSERTIONS INTO SIMPLE SINGLE-TABLE VIEW
  [[ incorrect then fix ]]
**************************************************************/

create view CSEE as
select sID, cName, major
from Apply
where major = 'CS' or major = 'EE';

select * from CSEE;

insert into CSEE values (111, 'Berkeley', 'CS');

create trigger CSEEinsert
instead of insert on CSEE
for each row
begin
  insert into Apply values (New.sID, New.cName, New.major, null);
end;

insert into CSEE values (111, 'Berkeley', 'CS');

select * from CSEE;
select * from Apply;

insert into CSEE values (222, 'Berkeley', 'biology');

select * from CSEE;
select * from Apply;

drop trigger CSEEinsert;

create trigger CSEEinsert
instead of insert on CSEE
for each row
when New.major = 'CS' or New.major = 'EE'
begin
  insert into Apply values (New.sID, New.cName, New.major, null);
end;

insert into CSEE values (333, 'Berkeley', 'biology');

select * from CSEE;
select * from Apply;

insert into CSEE values (333, 'Berkeley', 'EE');

select * from CSEE;
select * from Apply;

/**************************************************************
  SINGLE-TABLE VIEWS WITH AMBIGUOUS MODIFICATIONS
  aggregation, distinct, subquery referencing same table
**************************************************************/

create view HSgpa as
select sizeHS, avg(gpa) as avgGPA
from Student
group by sizeHS;

select * from HSgpa;

update HSgpa set avgGPA = 3.6 where sizeHS = 200;

create view Majors as
select distinct major from Apply;

select * from Majors;

insert into Majors values ('chemistry');

create view NonUnique as
select * from Student S1
where exists (select * from Student S2
              where S1.sID <> S2.sID
              and S2.GPA = S1.GPA and S2.sizeHS = S1.sizeHS);

select * from NonUnique;

delete from NonUnique where sName = 'Amy';

/**************************************************************
  JOIN VIEW: INSERTS, DELETES, UPDATES
**************************************************************/

create view Berk as
select Student.sID, major
from Student, Apply
where Student.sID = Apply.sID and cName = 'Berkeley';

select * from Berk;

create trigger BerkInsert
instead of insert on Berk
for each row
when New.sID in (select sID from Student)
begin
  insert into Apply values (New.sID, 'Berkeley', New.major, null);
end;

insert into Berk
  select sID, 'psychology' from Student
  where sID not in (select sID from Apply where cName = 'Berkeley');

select * from Berk;
select * from Apply;

create trigger BerkDelete
instead of delete on Berk
for each row
begin
  delete from Apply
  where sID = Old.sID and cName = 'Berkeley' and major = Old.major;
end;

delete from Berk where major = 'CS';

select * from Berk;
select * from Apply;

create trigger BerkUpdate
instead of update of major on Berk
for each row
begin
  update Apply
  set major = New.Major
  where sID = New.sID and cName = 'Berkeley' and major = Old.Major;
end;
 
update Berk set major = 'physics' where major = 'psychology';

select * from Berk;
select * from Apply;

update Berk set sID = 321 where sID = 123;

/**************************************************************
  VIEWS AND CONSTRAINTS
**************************************************************/

drop table Apply;
create table Apply(sID int, cName text, major text, decision text not null);

insert into CSEE values (123, 'Berkeley', 'CS');

drop table Apply;
create table Apply(sID int, cName text, major text, decision text, unique(sID,cName,major));

insert into CSEE values (123, 'Berkeley', 'CS');
insert into CSEE values (123, 'Berkeley', 'EE');

select * from Apply;
select * from CSEE;
select * from Berk;

insert into Berk values (123, 'EE');

update Berk set major = 'CS' where sID = 123;

/**************************************************************
  CLEANUP
**************************************************************/

drop view CSaccept;
drop view CSEE;
drop view HSgpa;
drop view Majors;
drop view NonUnique;
drop view Berk;
