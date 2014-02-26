/**************************************************************
  REFERENTIAL INTEGRITY (FOREIGN KEY) CONSTRAINTS
  SQLite: Everything works after setting PRAGMA foreign_keys = ON;
  MySQL: See required modifications below
  Postgres: Everything works
**************************************************************/

/**************************************************************
  DECLARING REFERENTIAL INTEGRITY
  All student IDs and college names in Apply must refer to
  valid students and colleges
**************************************************************/

create table College(cName text primary key, state text, enrollment int);

create table Student(sID int primary key, sName text, GPA real, sizeHS int);

create table Apply(sID int references Student(sID),
                   cName text references College(cName),
                   major text, decision text);

/**************************************************************
  REFERENTIAL INTEGRITY VIOLATIONS
  Insertions or updates in referencing table (Apply)
  Deletions or updates in referenced table (Student, College)
  Dropping referenced tables (Student, College)
**************************************************************/

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into College values ('Stanford', 'CA', 15000);
insert into College values ('Berkeley', 'CA', 36000);
insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');

update Apply set sID = 345 where sID = 123;
update Apply set sID = 234 where sID = 123;

delete from College where cName = 'Stanford';
delete from Student where sID = 234;
delete from Student where sID = 123;

update College set cName = 'Bezerkeley' where cName = 'Berkeley';

drop table Student;

/**************************************************************
  CASCADE AND SET NULL OPTIONS
  For deletions and updates in referenced table (Student, College)
**************************************************************/

drop table Apply;

create table Apply(sID int references Student(sID) on delete set null,
                   cName text references College(cName) on update cascade,
                   major text, decision text);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (345, 'Craig', 3.5, 500);

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (123, 'Berkeley', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');
insert into Apply values (345, 'Stanford', 'history', 'Y');
insert into Apply values (345, 'Stanford', 'CS', 'Y');

select * from Apply;
delete from Student where sID > 200;
select * from Apply;

update College set cName = 'Bezerkeley' where cName = 'Berkeley';
select * from Apply;

/**************************************************************
  INTRA-TABLE R.I., MULTI-ATTRIBUTE R.I., and TRUE CASCADE
**************************************************************/

create table T (A int, B int, C int, primary key (A,B),
                foreign key (B,C) references T(A,B) on delete cascade);
insert into T values (1,1,1);
insert into T values (2,1,1);
insert into T values (3,2,1);
insert into T values (4,3,2);
insert into T values (5,4,3);
insert into T values (6,5,4);
insert into T values (7,6,5);
insert into T values (8,7,6);

delete from T where A=1;
select * from T;

drop table College;
drop table Student;
drop table Apply;
drop table T;


/**************************************************************
***************************************************************
  MYSQL VERSION
  Requires varchar type for keys
  Requires foreign key declarations separate from attributes
  Requires InnoDB storage engine,
  Otherwise accepts constraints but does not enforce them
***************************************************************
**************************************************************/

/**************************************************************
  DECLARING REFERENTIAL INTEGRITY
  All student IDs and college names in Apply must refer to
  valid students and colleges
**************************************************************/

create table College(cName varchar(10) primary key, state text, enrollment int)
             engine = innodb;

create table Student(sID int primary key, sName text, GPA real, sizeHS int)
             engine = innodb;

create table Apply(sID int, cName varchar(10), major text, decision text,
                   foreign key (sID) references Student(sID),
                   foreign key (cName) references College(cName)) engine = innodb;

/**************************************************************
  REFERENTIAL INTEGRITY VIOLATIONS
  Insertions or updates in referencing table (Apply)
  Deletions or updates in referenced table (Student, College)
  Dropping referenced tables (Student, College)
**************************************************************/

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into College values ('Stanford', 'CA', 15000);
insert into College values ('Berkeley', 'CA', 36000);
insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');

update Apply set sID = 345 where sID = 123;
update Apply set sID = 234 where sID = 123;

delete from College where cName = 'Stanford';
delete from Student where sID = 234;
delete from Student where sID = 123;

update College set cName = 'Bezerkeley' where cName = 'Berkeley';

drop table Student;

/**************************************************************
  CASCADE AND SET NULL OPTIONS
  For deletions and updates in referenced table (Student, College)
**************************************************************/

drop table Apply;

create table Apply(sID int, cName varchar(10), major text, decision text,
                   foreign key (sID) references Student(sID) on delete set null,
                   foreign key (cName) references College(cName) on update cascade)
                  engine = innodb;

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (345, 'Craig', 3.5, 500);

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (123, 'Berkeley', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');
insert into Apply values (345, 'Stanford', 'history', 'Y');
insert into Apply values (345, 'Stanford', 'CS', 'Y');

select * from Apply;
delete from Student where sID > 200;
select * from Apply;

update College set cName = 'Bezerkeley' where cName = 'Berkeley';
select * from Apply;

/**************************************************************
  INTRA-TABLE R.I., MULTI-ATTRIBUTE R.I., and TRUE CASCADE
**************************************************************/

create table T (A int, B int, C int, primary key (A,B),
                foreign key (B,C) references T(A,B) on delete cascade)
               engine = innodb;
insert into T values (1,1,1);
insert into T values (2,1,1);
insert into T values (3,2,1);
insert into T values (4,3,2);
insert into T values (5,4,3);
insert into T values (6,5,4);
insert into T values (7,6,5);
insert into T values (8,7,6);

delete from T where A=1;
select * from T;

drop table Apply;
drop table College;
drop table Student;
drop table T;
