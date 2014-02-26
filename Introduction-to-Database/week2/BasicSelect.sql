/**************************************************************
  BASIC SELECT STATEMENTS
  Works for SQLite, MySQL, Postgres
**************************************************************/

/**************************************************************
  IDs, names, and GPAs of students with GPA > 3.6
**************************************************************/

select sID, sName, GPA
from Student
where GPA > 3.6;

/*** Same query without GPA ***/

select sID, sName
from Student
where GPA > 3.6;

/**************************************************************
  Student names and majors for which they've applied
**************************************************************/

select sName, major
from Student, Apply
where Student.sID = Apply.sID;

/*** Same query with Distinct, note difference from algebra ***/

select distinct sName, major
from Student, Apply
where Student.sID = Apply.sID;

/**************************************************************
  Names and GPAs of students with sizeHS < 1000 applying to
  CS at Stanford, and the application decision
**************************************************************/

select sname, GPA, decision
from Student, Apply
where Student.sID = Apply.sID
  and sizeHS < 1000 and major = 'CS' and cname = 'Stanford';

/**************************************************************
  All large campuses with CS applicants
**************************************************************/

select cName
from College, Apply
where College.cName = Apply.cName
  and enrollment > 20000 and major = 'CS';

/*** Fix error ***/

select College.cName
from College, Apply
where College.cName = Apply.cName
  and enrollment > 20000 and major = 'CS';

/*** Add Distinct ***/

select distinct College.cName
from College, Apply
where College.cName = Apply.cName
  and enrollment > 20000 and major = 'CS';

/**************************************************************
  Application information
**************************************************************/

select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName;

/*** Sort by decreasing GPA ***/

select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName
order by GPA desc;

/*** Then by increasing enrollment ***/

select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName
order by GPA desc, enrollment;

/**************************************************************
  Applicants to bio majors
**************************************************************/

select sID, major
from Apply
where major like '%bio%';

/*** Same query with Select * ***/

select *
from Apply
where major like '%bio%';

/**************************************************************
  Select * cross-product
**************************************************************/

select *
from Student, College;

/**************************************************************
  Add scaled GPA based on sizeHS
  Also note missing Where clause
**************************************************************/

select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0)
from Student;

/*** Rename result attribute ***/

select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0) as scaledGPA
from Student;
