/**************************************************************
  AUTOMATIC VIEW MODIFICATIONS
  Works for MySQL
  SQLite and Postgres don't support automatic view modifications
**************************************************************/

/**************************************************************
  DELETION FROM SIMPLE SINGLE-TABLE VIEW
**************************************************************/

create view CSaccept as
select sID, cName
from Apply
where major = 'CS' and decision = 'Y';

select * from CSaccept;
select * from Apply;

delete from CSaccept where sID = 123;

select * from CSaccept;
select * from Apply;

/**************************************************************
  INSERTION INTO SIMPLE SINGLE-TABLE VIEW
**************************************************************/

create view CSEE as
select sID, cName, major
from Apply
where major = 'CS' or major = 'EE';

select * from CSEE;

insert into CSEE values (111, 'Berkeley', 'CS');

select * from CSEE;
select * from Apply;

/**************************************************************
  DISAPPEARING INSERTION
**************************************************************/

insert into CSEE values (222, 'Berkeley', 'psychology');

select * from CSEE;
select * from Apply;

/**************************************************************
  NAIVE DISAPPEARING INSERTION
**************************************************************/

(create view CSaccept as
 select ID, location
 from Apply
 where major = 'CS' and decision = 'Y';)

insert into CSaccept values (333, 'Berkeley');

select * from CSaccept;
select * from Apply;

/**************************************************************
  WITH CHECK OPTION
**************************************************************/

create view CSaccept2 as
select sID, cName
from Apply
where major = 'CS' and decision = 'Y'
with check option;

insert into CSaccept2 values (444, 'Berkeley');

create view CSEE2 as
select sID, cName, major
from Apply
where major = 'CS' or major = 'EE'
with check option;

insert into CSEE2 values (444, 'Berkeley', 'psychology');
insert into CSEE2 values (444, 'Berkeley', 'CS');

select * from CSEE2;

/**************************************************************
  NON-MODIFIABLE SINGLE-TABLE VIEW
  Due to aggregation
**************************************************************/

create view HSgpa as
select sizeHS, avg(gpa)
from Student
group by sizeHS;

select * from HSgpa;

delete from HSgpa where sizeHS < 500;

insert into HSgpa values (3000, 3.0);

/**************************************************************
  NON-MODIFIABLE SINGLE-TABLE VIEW
  Due to distinct
**************************************************************/

create view Majors as
select distinct major from Apply;

select * from Majors;

insert into Majors values ('chemistry');

delete from Majors where major = 'CS';

/**************************************************************
  NON-MODIFIABLE SINGLE-TABLE VIEW
  Due to subquery referencing same table
**************************************************************/

create view NonUnique as
select * from Student S1
where exists (select * from Student S2
              where S1.sID <> S2.sID
              and S2.GPA = S1.GPA and S2.sizeHS = S1.sizeHS);

select * from NonUnique;

delete from NonUnique where sName = 'Amy';

/**************************************************************
  MODIFIABLE SINGLE-TABLE VIEW WITH SUBQUERY
**************************************************************/

create view Bio as
select * from Student
where sID in (select sID from Apply where major like 'bio%');

select * from Bio;

delete from Bio where sName = 'Bob';

select * from Bio;
select * from Student;

/**************************************************************
  DISAPPEARING INSERTION
**************************************************************/

insert into Bio values (555, 'Karen', 3.9, 1000);

select * from Bio;
select * from Student;

/**************************************************************
  WITH CHECK OPTION
**************************************************************/

create view Bio2 as
select * from Student
where sID in (select sID from Apply where major like 'bio%')
with check option;

insert into Bio2 values (666, 'Lori', 3.9, 1000);

/**************************************************************
  JOIN VIEW
  Not permitted in SQL standard
  (Also note schema after view name)
**************************************************************/

create view Stan(sID,aID,sName,major) as
select Student.sID, Apply.sID, sName, major
from Student, Apply
where Student.sID = Apply.sID and cName = 'Stanford';

select * from Stan;

/**************************************************************
  UPDATE TO JOIN VIEW
**************************************************************/

update Stan set sName = 'CS major' where major = 'CS';

select * from Stan;
select * from Student;
select * from Apply;

/**************************************************************
  DISAPPEARING UPDATE
**************************************************************/

select * from Stan;

update Stan set aID = 666 where aID = 123;

select * from Stan;
select * from Apply;
select * from Student;

/**************************************************************
  WITH CHECK OPTION
**************************************************************/

create view Stan2(sID,aID,sName,major) as
select Student.sID, Apply.sID, sName, major
from Student, Apply
where Student.sID = Apply.sID and cName = 'Stanford'
with check option;

select * from Stan2;

update Stan2 set aID = 777 where aID = 678;

/**************************************************************
  INSERTIONS INTO JOIN VIEW
**************************************************************/

insert into Stan(sID,sName) values (777, 'Lance');
select * from Stan;
select * from Apply;
select * from Student;

insert into Stan2(sID,sName) values (888, 'Mary');

insert into Apply values (888, 'Stanford', 'history', 'Y');
insert into Stan2(sID,sName) values (888,'Mary');

select * from Stan2;
select * from Student;

insert into Apply values (999, 'MIT', 'history', 'Y');
insert into Stan2(sID,sName) values (999,'Nancy');

/**************************************************************
  DELETIONS FROM JOIN VIEW (not allowed)
**************************************************************/

delete from Stan where sID = 678;

/**************************************************************
  CLEANUP
**************************************************************/

drop view CSaccept;
drop view CSEE;
drop view CSaccept2;
drop view CSEE2;
drop view HSgpa;
drop view Majors;
drop view NonUnique;
drop view Bio;
drop view Bio2;
drop view Stan;
drop view Stan2;
