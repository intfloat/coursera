/**************************************************************
  BASIC RECURSION
  Works for Postgres
  SQLite and MySQL don't support WITH RECURSIVE
**************************************************************/

/**************************************************************
  EXAMPLE 1: Ancestors
  Find all of Mary's ancestors
**************************************************************/

create table ParentOf(parent text, child text);

insert into ParentOf values ('Alice', 'Carol');
insert into ParentOf values ('Bob', 'Carol');
insert into ParentOf values ('Carol', 'Dave');
insert into ParentOf values ('Carol', 'George');
insert into ParentOf values ('Dave', 'Mary');
insert into ParentOf values ('Eve', 'Mary');
insert into ParentOf values ('Mary', 'Frank');

with recursive
  Ancestor(a,d) as (select parent as a, child as d from ParentOf
                    union
                    select Ancestor.a, ParentOf.child as d
                    from Ancestor, ParentOf
                    where Ancestor.d = ParentOf.parent)
select a from Ancestor where d = 'Mary';

/*** Also find ancestors of Frank, George, Bob ***/

/**************************************************************
  EXAMPLE 2: Company hierarchy
  Find total salary cost of project 'X'
**************************************************************/

create table Employee(ID int, salary int);
create table Manager(mID int, eID int);
create table Project(name text, mgrID int);

insert into Employee values (123, 100);
insert into Employee values (234, 90);
insert into Employee values (345, 80);
insert into Employee values (456, 70);
insert into Employee values (567, 60);
insert into Manager values (123, 234);
insert into Manager values (234, 345);
insert into Manager values (234, 456);
insert into Manager values (345, 567);
insert into Project values ('X', 123);

with recursive
  Superior as (select * from Manager
               union
               select S.mID, M.eID
               from Superior S, Manager M
               where S.eID = M.mID )
select sum(salary)
from Employee
where ID in
  (select mgrID from Project where name = 'X'
   union
   select eID from Project, Superior
   where Project.name = 'X' AND Project.mgrID = Superior.mID );

/*** Alternative formulation tied specifically to project 'X' **/

with recursive
  Xemps(ID) as (select mgrID as ID from Project where name = 'X'
                union
                select eID as ID
                from Manager M, Xemps X
                where M.mID = X.ID)
select sum(salary)
from Employee
where ID in (select ID from Xemps);

/*** Total salary costs for projects 'Y' and 'Z' ***/

insert into Project values ('Y', 234);
insert into Project values ('Z', 456);

with recursive
  Yemps(ID) as (select mgrID as ID from Project where name = 'Y'
                union
                select eID as ID
                from Manager M, Yemps Y
                where M.mID = Y.ID),
  Zemps(ID) as (select mgrID as ID from Project where name = 'Z'
                union
                select eID as ID
                from Manager M, Zemps Z
                where M.mID = Z.ID)
select 'Y-total', sum(salary)
from Employee
where ID in (select ID from Yemps)
union
select 'Z-total', sum(salary)
from Employee
where ID in (select ID from Zemps);

/**************************************************************
  EXAMPLE 3: Airline flights
  Find cheapest way to fly from 'A' to 'B'
**************************************************************/

create table Flight(orig text, dest text, airline text, cost int);

insert into Flight values ('A', 'ORD', 'United', 200);
insert into Flight values ('ORD', 'B', 'American', 100);
insert into Flight values ('A', 'PHX', 'Southwest', 25);
insert into Flight values ('PHX', 'LAS', 'Southwest', 30);
insert into Flight values ('LAS', 'CMH', 'Frontier', 60);
insert into Flight values ('CMH', 'B', 'Frontier', 60);
insert into Flight values ('A', 'B', 'JetBlue', 195);

/*** First find all costs ***/

with recursive
  Route(orig,dest,total) as
    (select orig, dest, cost as total from Flight
     union
     select R.orig, F.dest, cost+total as total
     from Route R, Flight F
     where R.dest = F.orig)
select * from Route
where orig = 'A' and dest = 'B';

/*** Then find minimum; note returns cheapest cost but not route ***/

with recursive
  Route(orig,dest,total) as
    (select orig, dest, cost as total from Flight
     union
     select R.orig, F.dest, cost+total as total
     from Route R, Flight F
     where R.dest = F.orig)
select min(total) from Route
where orig = 'A' and dest = 'B';

/*** Alternative formuation tied specifically to origin 'A' ***/

with recursive
  FromA(dest,total) as
    (select dest, cost as total from Flight where orig = 'A'
     union
     select F.dest, cost+total as total
     from FromA FA, Flight F
     where FA.dest = F.orig)
select * from FromA;

with recursive
  FromA(dest,total) as
    (select dest, cost as total from Flight where orig = 'A'
     union
     select F.dest, cost+total as total
     from FromA FA, Flight F
     where FA.dest = F.orig)
select min(total) from FromA where dest = 'B';

/*** Alternative formuation tied specifically to destination 'B' ***/

with recursive
  ToB(orig,total) as
    (select orig, cost as total from Flight where dest = 'B'
     union
     select F.orig, cost+total as total
     from Flight F, ToB TB
     where F.dest = TB.orig)
select * from ToB;

with recursive
  ToB(orig,total) as
    (select orig, cost as total from Flight where dest = 'B'
     union
     select F.orig, cost+total as total
     from Flight F, ToB TB
     where F.dest = TB.orig)
select min(total) from ToB where orig = 'A';

/*** Add flight that creates a cycle ***/

insert into Flight values ('CMH', 'PHX', 'Frontier', 80);

/*** Now all queries loop indefinitely ***/

with recursive
  Route(orig,dest,total) as
    (select orig, dest, cost as total from Flight
     union
     select R.orig, F.dest, cost+total as total
     from Route R, Flight F
     where R.dest = F.orig)
select * from Route
where orig = 'A' and dest = 'B';

/*** Try only adding cheaper routes ***/

with recursive
  Route(orig,dest,total) as
    (select orig, dest, cost as total from Flight
     union
     select R.orig, F.dest, cost+total as total
     from Route R, Flight F
     where R.dest = F.orig
     and cost+total < all (select total from Route R2
                           where R2.orig = R.orig and R2.dest = F.dest))
select * from Route
where orig = 'A' and dest = 'B';

/*** Limit number of results; doesn't work when min() is added ***/

with recursive
  Route(orig,dest,total) as
    (select orig, dest, cost as total from Flight
     union
     select R.orig, F.dest, cost+total as total
     from Route R, Flight F
     where R.dest = F.orig)
select * from Route
where orig = 'A' and dest = 'B' limit 20;

with recursive
  Route(orig,dest,total) as
    (select orig, dest, cost as total from Flight
     union
     select R.orig, F.dest, cost+total as total
     from Route R, Flight F
     where R.dest = F.orig)
select min(total) from Route
where orig = 'A' and dest = 'B' limit 20;

/*** Enforce maximum length of route ***/

with recursive
  Route(orig,dest,total,length) as
    (select orig, dest, cost as total, 1 from Flight
     union
     select R.orig, F.dest, cost+total as total, R.length+1 as length
     from Route R, Flight F
     where R.length < 10 and R.dest = F.orig)
select * from Route
where orig = 'A' and dest = 'B';

with recursive
  Route(orig,dest,total,length) as
    (select orig, dest, cost as total, 1 from Flight
     union
     select R.orig, F.dest, cost+total as total, R.length+1 as length
     from Route R, Flight F
     where R.length < 10 and R.dest = F.orig)
select min(total) from Route
where orig = 'A' and dest = 'B';

with recursive
  Route(orig,dest,total,length) as
    (select orig, dest, cost as total, 1 from Flight
     union
     select R.orig, F.dest, cost+total as total, R.length+1 as length
     from Route R, Flight F
     where R.length < 100000 and R.dest = F.orig)
select min(total) from Route
where orig = 'A' and dest = 'B';

/**************************************************************
   CLEANUP
**************************************************************/

drop table ParentOf;
drop table Employee;
drop table Manager;
drop table Project;
drop table Flight;
