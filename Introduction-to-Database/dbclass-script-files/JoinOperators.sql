/**************************************************************
  JOIN OPERATORS
  Works for Postgres
  MySQL doesn't support FULL OUTER JOIN
  SQLite doesn't support RIGHT or FULL OUTER JOIN
**************************************************************/

/**************************************************************
  INNER JOIN
  Student names and majors for which they've applied
**************************************************************/

select distinct sName, major
from Student, Apply
where Student.sID = Apply.sID;

/*** Rewrite using INNER JOIN ***/

select distinct sName, major
from Student inner join Apply
on Student.sID = Apply.sID;

/*** Abbreviation is JOIN ***/

select distinct sName, major
from Student join Apply
on Student.sID = Apply.sID;

/**************************************************************
  INNER JOIN WITH ADDITIONAL CONDITIONS
  Names and GPAs of students with sizeHS < 1000 applying to
  CS at Stanford
**************************************************************/

select sName, GPA
from Student, Apply
where Student.sID = Apply.sID
  and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** Rewrite using JOIN ***/

select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** Can move everything into JOIN ON condition ***/

select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/**************************************************************
  THREE-WAY INNER JOIN
  Application info: ID, name, GPA, college name, enrollment
**************************************************************/

select Apply.sID, sName, GPA, Apply.cName, enrollment
from Apply, Student, College
where Apply.sID = Student.sID and Apply.cName = College.cName;

/*** Rewrite using three-way JOIN ***/
/*** Works in SQLite and MySQL but not Postgres ***/

select Apply.sID, sName, GPA, Apply.cName, enrollment
from Apply join Student join College
on Apply.sID = Student.sID and Apply.cName = College.cName;

/*** Rewrite using binary JOIN ***/

select Apply.sID, sName, GPA, Apply.cName, enrollment
from (Apply join Student on Apply.sID = Student.sID) join College on Apply.cName = College.cName;

/**************************************************************
  NATURAL JOIN
  Student names and majors for which they've applied
**************************************************************/

select distinct sName, major
from Student inner join Apply
on Student.sID = Apply.sID;

/*** Rewrite using NATURAL JOIN ***/

select distinct sName, major
from Student natural join Apply;

/*** Like relational algebra, eliminates duplicate columns ***/

select *
from Student natural join Apply;

select distinct sID
from Student natural join Apply;

/*** Would get ambiguity error with cross-product ***/

select distinct sID
from Student, Apply;

/**************************************************************
  NATURAL JOIN WITH ADDITIONAL CONDITIONS
  Names and GPAs of students with sizeHS < 1000 applying to
  CS at Stanford
**************************************************************/

select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** Rewrite using NATURAL JOIN ***/

select sName, GPA
from Student natural join Apply
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** USING clause considered safer ***/

select sName, GPA
from Student join Apply using(sID)
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/**************************************************************
  SELF-JOIN
  Pairs of students with same GPA
**************************************************************/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID < S2.sID;

/*** Rewrite using JOIN and USING (disallowed) ***/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1 join Student S2 on S1.sID < S2.sID using(GPA);

/*** Without ON clause ***/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1 join Student S2 using(GPA)
where S1.sID < S2.sID;

/**************************************************************
  SELF NATURAL JOIN
**************************************************************/

select *
from Student S1 natural join Student S2;

/*** Verify equivalence to Student ***/

select * from Student;

/**************************************************************
  LEFT OUTER JOIN
  Student application info: name, ID, college name, major
**************************************************************/

select sName, sID, cName, major
from Student inner join Apply using(sID);

/*** Include students who haven't applied anywhere ***/

select sName, sID, cName, major
from Student left outer join Apply using(sID);

/*** Abbreviation is LEFT JOIN ***/

select sName, sID, cName, major
from Student left join Apply using(sID);

/*** Using NATURAL OUTER JOIN ***/

select sName, sID, cName, major
from Student natural left outer join Apply;

/*** Can simulate without any JOIN operators ***/

select sName, Student.sID, cName, major
from Student, Apply
where Student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from Student
where sID not in (select sID from Apply);

/*** Instead include applications without matching students ***/

insert into Apply values (321, 'MIT', 'history', 'N');
insert into Apply values (321, 'MIT', 'psychology', 'Y');

select sName, sID, cName, major
from Apply natural left outer join Student;

/**************************************************************
  RIGHT OUTER JOIN
  Student application info: name, ID, college name, major
**************************************************************/

/*** Include applications without matching students ***/

select sName, sID, cName, major
from Student natural right outer join Apply;

/**************************************************************
  FULL OUTER JOIN
  Student application info
**************************************************************/

/*** Include students who haven't applied anywhere ***/
/*** and applications without matching students ***/

select sName, sID, cName, major
from Student full outer join Apply using(sID);

/*** Can simulate with LEFT and RIGHT outerjoins ***/
/*** Note UNION eliminates duplicates ***/

select sName, sID, cName, major
from Student left outer join Apply using(sID)
union
select sName, sID, cName, major
from Student right outer join Apply using(sID);

/*** Can simulate without any JOIN operators ***/

select sName, Student.sID, cName, major
from Student, Apply
where Student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from Student
where sID not in (select sID from Apply)
union
select NULL, sID, cName, major
from Apply
where sID not in (select sID from Student);

/**************************************************************
  THREE-WAY OUTER JOIN
  Not associative
**************************************************************/

create table T1 (A int, B int);
create table T2 (B int, C int);
create table T3 (A int, C int);
insert into T1 values (1,2);
insert into T2 values (2,3);
insert into T3 values (4,5);

select A,B,C
from (T1 natural full outer join T2) natural full outer join T3;

select A,B,C
from T1 natural full outer join (T2 natural full outer join T3);

drop table T1;
drop table T2;
drop table T3;
