/**************************************************************
  NULL VALUES
  Works for SQLite, MySQL, Postgres
**************************************************************/

insert into Student values (432, 'Kevin', null, 1500);
insert into Student values (321, 'Lori', null, 2500);

select * from Student;

/**************************************************************
  All students with high GPA
**************************************************************/

select sID, sName, GPA
from Student
where GPA > 3.5;

/*** Now low GPA ***/

select sID, sName, GPA
from Student
where GPA <= 3.5;

/*** Now either high or low GPA ***/

select sID, sName, GPA
from Student
where GPA > 3.5 or GPA <= 3.5;

/*** Now all students ***/

select sID, sName from Student;

/*** Now use 'is null' ***/

select sID, sName, GPA
from Student
where GPA > 3.5 or GPA <= 3.5 or GPA is null;

/**************************************************************
  All students with high GPA or small HS
**************************************************************/

select sID, sName, GPA, sizeHS
from Student
where GPA > 3.5 or sizeHS < 1600;

/*** Add large HS ***/

select sID, sName, GPA, sizeHS
from Student
where GPA > 3.5 or sizeHS < 1600 or sizeHS >= 1600;

/**************************************************************
  Number of students with non-null GPAs
**************************************************************/

select count(*)
from Student
where GPA is not null;

/*** Number of distinct GPA values among them ***/

select count(distinct GPA)
from Student
where GPA is not null;

/*** Drop non-null condition ***/

select count(distinct GPA)
from Student;

/*** Drop count ***/

select distinct GPA
from Student;
