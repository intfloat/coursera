/**************************************************************
  TABLE VARIABLES AND SET OPERATORS
  Works for SQLite, Postgres
  MySQL doesn't support Intersect or Except
**************************************************************/

/**************************************************************
  Application information
**************************************************************/

select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName;

/*** Introduce table variables ***/

select S.sID, S.sName, S.GPA, A.cName, C.enrollment
from Student S, College C, Apply A
where A.sID = S.sID and A.cName = C.cName;

/**************************************************************
  Pairs of students with same GPA
**************************************************************/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA;

/*** Get rid of self-pairings ***/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID <> S2.sID;

/*** Get rid of reverse-pairings ***/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID < S2.sID;

/**************************************************************
  List of college names and student names
**************************************************************/

select cName from College
union
select sName from Student;

/*** Add 'As name' to both sides ***/

select cName as name from College
union
select sName as name from Student;

/*** Change to Union All ***/

select cName as name from College
union all
select sName as name from Student;

/*** Notice not sorted any more (SQLite), add order by cName ***/

select cName as name from College
union all
select sName as name from Student
order by name;

/**************************************************************
  IDs of students who applied to both CS and EE
**************************************************************/

select sID from Apply where major = 'CS'
intersect
select sID from Apply where major = 'EE';

/**************************************************************
  IDs of students who applied to both CS and EE
  Some systems don't support intersect
**************************************************************/

select A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';

/*** Why so many duplicates? Look at Apply table ***/
/*** Add Distinct ***/

select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';

/**************************************************************
  IDs of students who applied to CS but not EE
**************************************************************/

select sID from Apply where major = 'CS'
except
select sID from Apply where major = 'EE';

/**************************************************************
  IDs of students who applied to CS but not EE
  Some systems don't support except
**************************************************************/

select A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major <> 'EE';

/*** Add Distinct ***/

select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major <> 'EE';

/*** Can't do it with constructs we have so far ***/
