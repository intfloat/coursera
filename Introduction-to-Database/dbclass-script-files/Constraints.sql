/**************************************************************
  CONSTRAINTS: NON-NULL, KEY, ATTRIBUTE-BASED AND TUPLE-BASED,
  GENERAL ASSERTIONS
  SQLite, Postgres: everything works except CHECK constraints
    with subqueries, general assertions
  MySQL: does not allow primary key or unique on text attributes;
     allows declaration of any CHECK constraints but does not
     enforce them; no general assertions
**************************************************************/

/**************************************************************
  NON-NULL CONSTRAINTS
  GPA must not be NULL
**************************************************************/

create table Student(sID int, sName text, GPA real not null, sizeHS int);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, null);
insert into Student values (345, 'Craig', null, 500);
update Student set GPA = null where sID = 123;
update Student set GPA = null where sID = 456;

drop table Student;

/**************************************************************
  PRIMARY KEYS
  Student IDs are unique
**************************************************************/

create table Student(sID int primary key, sName text, GPA real, sizeHS int);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (123, 'Craig', 3.5, 500);
update Student set sID = 123 where sName = 'Bob';
update Student set sID = sID - 111;
update Student set sID = sID + 111;

drop table Student;

/**************************************************************
  ONLY ONE PRIMARY KEY ALLOWED
**************************************************************/

create table Student(sID int primary key, sName text primary key,
                     GPA real, sizeHS int);

/**************************************************************
  ONLY ONE PRIMARY KEY ALLOWED - MySQL version
**************************************************************/

create table Student(sID int primary key, sName varchar(10) primary key,
                     GPA real, sizeHS int);

/**************************************************************
  BUT ANY NUMBER OF UNIQUE KEYS
**************************************************************/

create table Student(sID int primary key, sName text unique,
                     GPA real, sizeHS int unique);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (345, 'Amy', 3.5, 500);
insert into Student values (456, 'Doris', 3.9, 1000);
insert into Student values (567, 'Amy', 3.8, 1500);

drop table Student;

/**************************************************************
  BUT ANY NUMBER OF UNIQUE KEYS - MySQL version
**************************************************************/

create table Student(sID int primary key, sName varchar(10) unique,
                     GPA real, sizeHS int unique);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (345, 'Amy', 3.5, 500);
insert into Student values (456, 'Doris', 3.9, 1000);
insert into Student values (567, 'Amy', 3.8, 1500);

drop table Student;

/**************************************************************
  MULTI-ATTRIBUTE KEYS
  College names
**************************************************************/

create table College(cName text, state text, enrollment int,
                     primary key (cName,state));

insert into College values ('Mason', 'CA', 10000);
insert into College values ('Mason', 'NY', 5000);
insert into College values ('Mason', 'CA', 2000);

drop table College;

/**************************************************************
  MULTI-ATTRIBUTE KEYS - MySQL version
  College names
**************************************************************/

create table College(cName varchar(10), state varchar(2), enrollment int,
                     primary key (cName,state));

insert into College values ('Mason', 'CA', 10000);
insert into College values ('Mason', 'NY', 5000);
insert into College values ('Mason', 'CA', 2000);

drop table College;

/**************************************************************
  MULTI-ATTRIBUTE KEYS
  Semantic restrictions: students can apply to each college
  once and each major once
**************************************************************/

create table Apply(sID int, cName text, major text, decision text,
                   unique(sID,cName), unique(sID,major));

insert into Apply values (123, 'Stanford', 'CS', null);
insert into Apply values (123, 'Berkeley', 'EE', null);
insert into Apply values (123, 'Stanford', 'biology', null);
insert into Apply values (234, 'Stanford', 'biology', null);
insert into Apply values (123, 'MIT', 'EE', null);
insert into Apply values (123, 'MIT', 'biology', null);
update Apply set major = 'CS' where cName = 'MIT';
insert into Apply values (123, null, null, 'Y');
insert into Apply values (123, null, null, 'N');

drop table Apply;

/**************************************************************
  MULTI-ATTRIBUTE KEYS - MySQL version
  Semantic restrictions: students can apply to each college
  once and each major once
**************************************************************/

create table Apply(sID int, cName varchar(10), major varchar(10),
                   decision text, unique(sID,cName), unique(sID,major));

insert into Apply values (123, 'Stanford', 'CS', null);
insert into Apply values (123, 'Berkeley', 'EE', null);
insert into Apply values (123, 'Stanford', 'biology', null);
insert into Apply values (123, 'MIT', 'EE', null);
insert into Apply values (123, 'MIT', 'biology', null);
update Apply set major = 'CS' where cName = 'MIT';
insert into Apply values (123, null, null, 'Y');
insert into Apply values (123, null, null, 'N');

drop table Apply;

/**************************************************************
  ATTRIBUTE-BASED CONSTRAINTS
  GPA and sizeHS are in range
  MySQL accepts CHECK constraints but does not enforce
**************************************************************/

create table Student(sID int, sName text,
                     GPA real check(GPA <= 4.0 and GPA > 0.0),
                     sizeHS int check(sizeHS < 5000));

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 4.6, 1500);
update Student set sizeHS = 6*sizeHS;

drop table Student;

/**************************************************************
  TUPLE-BASED CONSTRAINTS
  No CS admits to Stanford
  MySQL accepts CHECK constraints but does not enforce them
**************************************************************/

create table Apply(sID int, cName text, major text, decision text,
                   check(decision = 'N' or cName <> 'Stanford'
                         or major <> 'CS'));

insert into Apply values (123, 'Stanford', 'CS', 'N');
insert into Apply values (123, 'MIT', 'CS', 'Y');
insert into Apply values (123, 'Stanford', 'CS', 'Y');
update Apply set decision = 'Y' where cName = 'Stanford';
update Apply set cName = 'Stanford' where cName = 'MIT';

drop table Apply;

/**************************************************************
  IMPLEMENTING NOT-NULL CONSTRAINTS
  MySQL accepts CHECK constraints but does not enforce them
**************************************************************/

create table Student(sID int, sName text,
                     GPA real check(GPA is not null), sizeHS int);

insert into Student values (123, 'Amy', null, 1000);

drop table Student;

/**************************************************************
  IMPLEMENTING KEYS
  Table T(A), A is a key
  SQLite, Postgres: several issues
  MySQL: accepts but does not enforce
**************************************************************/

create table T(A int check(A not in (select A from T)));

create table T(A int check((select count(distinct A) from T) =
                           (select count(*) from T)));

/**************************************************************
  SUBQUERIES IN CHECK CONSTRAINTS
  SQLite, Postgres: no subqueries in CHECK constraints
  MySQL: accepts but does not enforce
**************************************************************/

create table Student(sID int, sName text, GPA real, sizeHS int);

create table Apply(sID int, cName text, major text, decision text,
                   check(sID in (select sID from Student)));

create table College(cName text, state text, enrollment int,
                     check(enrollment > (select max(sizeHS) from Student)));

drop table Student;
drop table Apply;
drop table College;

/**************************************************************
  GENERAL ASSERTIONS
  SQL standard but not implemented by any system
**************************************************************/

create assertion Key
check ((select count(distinct A) from T) =
       (select count(*) from T)));

create assertion ReferentialIntegrity
check (not exists (select * from Apply
                   where sID not in (select sID from Student)));

create assertion Sizes
check (not exists (select * from College
                   where enrollment <= (select max(sizeHS) from Student)));

create assertion AvgAccept
check (3.0 < (select avg(GPA) from Student
              where sID in 
                (select SID from Apply where decision = 'Y')));
