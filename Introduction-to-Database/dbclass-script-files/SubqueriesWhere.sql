/**************************************************************
  SUBQUERIES IN THE WHERE CLAUSE
  Works for MySQL, Postgres
  SQLite doesn't support All or Any
**************************************************************/

/**************************************************************
  IDs and names of students applying to CS
**************************************************************/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Same query written without 'In'
**************************************************************/

select sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*** Fix error ***/

select Student.sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*** Remove duplicates ***/

select distinct Student.sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/**************************************************************
  Just names of students applying to CS
**************************************************************/

select sName
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Same query written without 'In'
**************************************************************/

select sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*** Remove duplicates (still incorrect) ***/

select distinct sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/**************************************************************
  Duplicates are important: average GPA of CS applicants
**************************************************************/

select GPA
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Alternative (incorrect) queries without 'In'
**************************************************************/

select GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

select distinct GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/**************************************************************
  Students who applied to CS but not EE
  (query we used 'Except' for earlier)
**************************************************************/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and sID not in (select sID from Apply where major = 'EE');

/*** Change to 'not sID in' ***/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and not sID in (select sID from Apply where major = 'EE');

/**************************************************************
  Colleges such that some other college is in the same state
**************************************************************/

select cName, state
from College C1
where exists (select * from College C2
              where C2.state = C1.state);

/*** Fix error ***/

select cName, state
from College C1
where exists (select * from College C2
              where C2.state = C1.state and C2.cName <> C1.cName);

/**************************************************************
  Biggest college
**************************************************************/

select cName
from College C1
where not exists (select * from College C2
                  where C2.enrollment > C1.enrollment);

/*** Similar: student with highest GPA  ***/

select sName
from Student C1
where not exists (select * from Student C2
                  where C2.GPA > C1.GPA);

/*** Add GPA ***/

select sName, GPA
from Student C1
where not exists (select * from Student C2
                  where C2.GPA > C1.GPA);

/**************************************************************
  Highest GPA with no subquery
**************************************************************/

select S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;

/*** Remove duplicates (still incorrect) ***/

select distinct S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;

/**************************************************************
  Highest GPA using ">= all"
**************************************************************/

select sName, GPA
from Student
where GPA >= all (select GPA from Student);

/**************************************************************
  Higher GPA than all other students
**************************************************************/

select sName, GPA
from Student S1
where GPA > all (select GPA from Student S2
                 where S2.sID <> S1.sID);

/*** Similar: higher enrollment than all other colleges  ***/

select cName
from College S1
where enrollment > all (select enrollment from College S2
                        where S2.cName <> S1.cName);

/*** Same query using 'Not <= Any' ***/

select cName
from College S1
where not enrollment <= any (select enrollment from College S2
                             where S2.cName <> S1.cName);

/**************************************************************
  Students not from the smallest HS
**************************************************************/

select sID, sName, sizeHS
from Student
where sizeHS > any (select sizeHS from Student);

/**************************************************************
  Students not from the smallest HS
  Some systems don't support Any/All
**************************************************************/

select sID, sName, sizeHS
from Student S1
where exists (select * from Student S2
              where S2.sizeHS < S1.sizeHS);

/**************************************************************
  Students who applied to CS but not EE
**************************************************************/

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
  and sID <> any (select sID from Apply where major = 'EE');

/*** Subtle error, fix ***/

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
  and not sID = any (select sID from Apply where major = 'EE');
