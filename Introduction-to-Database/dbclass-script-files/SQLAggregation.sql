/**************************************************************
  AGGREGATION
  Works for SQLite, MySQL
  Postgres doesn't allow ambiguous Select columns in Group-by queries
**************************************************************/

/**************************************************************
  Average GPA of all students
**************************************************************/

select avg(GPA)
from Student;

/**************************************************************
  Lowest GPA of students applying to CS
**************************************************************/

select min(GPA)
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*** Average GPA of students applying to CS ***/

select avg(GPA)
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*** Fix incorrect counting of GPAs ***/

select avg(GPA)
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Number of colleges bigger than 15,000
**************************************************************/

select count(*)
from College
where enrollment > 15000;

/**************************************************************
  Number of students applying to Cornell
**************************************************************/

select count(*)
from Apply
where cName = 'Cornell';

/*** Show why incorrect result, fix using Count Distinct ***/

select *
from Apply
where cName = 'Cornell';

select Count(Distinct sID)
from Apply
where cName = 'Cornell';

/**************************************************************
  Students such that number of other students with same GPA is
  equal to number of other students with same sizeHS
**************************************************************/

select *
from Student S1
where (select count(*) from Student S2
       where S2.sID <> S1.sID and S2.GPA = S1.GPA) =
      (select count(*) from Student S2
       where S2.sID <> S1.sID and S2.sizeHS = S1.sizeHS);

/**************************************************************
  Amount by which average GPA of students applying to CS
  exceeds average of students not applying to CS
**************************************************************/

select CS.avgGPA - NonCS.avgGPA
from (select avg(GPA) as avgGPA from Student
      where sID in (
         select sID from Apply where major = 'CS')) as CS,
     (select avg(GPA) as avgGPA from Student
      where sID not in (
         select sID from Apply where major = 'CS')) as NonCS;

/*** Same using subqueries in Select ***/

select (select avg(GPA) as avgGPA from Student
        where sID in (
           select sID from Apply where major = 'CS')) -
       (select avg(GPA) as avgGPA from Student
        where sID not in (
           select sID from Apply where major = 'CS')) as d
from Student;

/*** Remove duplicates ***/

select distinct (select avg(GPA) as avgGPA from Student
        where sID in (
           select sID from Apply where major = 'CS')) -
       (select avg(GPA) as avgGPA from Student
        where sID not in (
           select sID from Apply where major = 'CS')) as d
from Student;

/**************************************************************
  Number of applications to each college
**************************************************************/

select cName, count(*)
from Apply
group by cName;

/*** First do query to picture grouping ***/

select *
from Apply
order by cName;

/*** Now back to query we want ***/

select cName, count(*)
from Apply
group by cName;

/**************************************************************
  College enrollments by state
**************************************************************/

select state, sum(enrollment)
from College
group by state;

/**************************************************************
  Minimum + maximum GPAs of applicants to each college & major
**************************************************************/

select cName, major, min(GPA), max(GPA)
from Student, Apply
where Student.sID = Apply.sID
group by cName, major;

/*** First do query to picture grouping ***/

select cName, major, GPA
from Student, Apply
where Student.sID = Apply.sID
order by cName, major;

/*** Now back to query we want ***/

select cName, major, min(GPA), max(GPA)
from Student, Apply
where Student.sID = Apply.sID
group by cName, major;

/*** Widest spread ***/

select max(mx-mn)
from (select cName, major, min(GPA) as mn, max(GPA) as mx
      from Student, Apply
      where Student.sID = Apply.sID
      group by cName, major) M;

/**************************************************************
  Number of colleges applied to by each student
**************************************************************/

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** First do query to picture grouping ***/

select Student.sID, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

/*** Now back to query we want ***/

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Add student name ***/

select Student.sID, sName, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** First do query to picture grouping ***/

select Student.sID, sName, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

/*** Now back to query we want ***/

select Student.sID, sName, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Add college (shouldn't work but does in some systems) ***/

select Student.sID, sName, count(distinct cName), cName
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Back to query to picture grouping ***/

select Student.sID, sName, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

/**************************************************************
  Number of colleges applied to by each student, including
  0 for those who applied nowhere
**************************************************************/

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Now add 0 counts ***/

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID
union
select sID, 0
from Student
where sID not in (select sID from Apply);

/**************************************************************
  Colleges with fewer than 5 applications
**************************************************************/

select cName
from Apply
group by cName
having count(*) < 5;

/*** Same query without Group-by or Having ***/

select cName
from Apply A1
where 5 > (select count(*) from Apply A2 where A2.cName = A1.cName);

/*** Remove duplicates ***/

select distinct cName
from Apply A1
where 5 > (select count(*) from Apply A2 where A2.cName = A1.cName);

/*** Back to original Group-by form, fewer than 5 applicants ***/

select cName
from Apply
group by cName
having count(distinct sID) < 5;

/**************************************************************
  Majors whose applicant's maximum GPA is below the average
**************************************************************/

select major
from Student, Apply
where Student.sID = Apply.sID
group by major
having max(GPA) < (select avg(GPA) from Student);
