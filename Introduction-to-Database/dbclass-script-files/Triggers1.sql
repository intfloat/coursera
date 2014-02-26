/**************************************************************
  TRIGGERS - PART 1
  Designed for SQLite
  Works for Postgres but with post-statement activation,
    requires trigger actions specified as stored procedures
  MySQL doesn't support WHEN, UPDATE event with attributes,
    multiple triggers on same event, trigger chaining
**************************************************************/

/**************************************************************
  AFTER-INSERT TRIGGER
  New students with GPA between 3.3 and 3.6 automatically apply
  to geology major at Stanford and biology at MIT
**************************************************************/

create trigger R1
after insert on Student
for each row
when New.GPA > 3.3 and New.GPA <= 3.6
begin
  insert into Apply values (New.sID, 'Stanford', 'geology', null);
  insert into Apply values (New.sID, 'MIT', 'biology', null);
end;

insert into Student values ('111', 'Kevin', 3.5, 1000);
insert into Student values ('222', 'Lori', 3.8, 1000);
select * from Student;
select * from Apply;

insert into Student select sID+1, sName, GPA, sizeHS from Student;
select * from Student;
select * from Apply;

/**************************************************************
  AFTER-DELETE TRIGGER
  Cascaded delete for Apply(sID) references Student(sID)
**************************************************************/

create trigger R2
after delete on Student
for each row
begin
  delete from Apply where sID = Old.sID;
end;

delete from Student where sID > 500;
select * from Student;
select * from Apply;

/**************************************************************
  AFTER-UPDATE TRIGGER
  Cascaded update for Apply(cName) references College(cName)
**************************************************************/

create trigger R3
after update of cName on College
for each row
begin
  update Apply
  set cName = New.cName
  where cName = Old.cName;
end;

update College set cName = 'The Farm' where cName = 'Stanford';
update College set cName = 'Bezerkeley' where cName = 'Berkeley';
select * from College;
select * from Apply;

/**************************************************************
  BEFORE TRIGGERS, ACTION RAISING ERROR
  Enforce key constraint on College.cName
**************************************************************/

create trigger R4
before insert on College
for each row
when exists (select * from College where cName = New.cName)
begin
  select raise(ignore);
end;

create trigger R5
before update of cName on College
for each row
when exists (select * from College where cName = New.cName)
begin
  select raise(ignore);
end;

insert into College values ('Stanford', 'CA', 15000);
insert into College values ('MIT', 'hello', 10000);
select * from College;

update College set cName = 'Berkeley' where cName = 'Bezerkeley';
select * from College;
update College set cName = 'Stanford' where cName = 'The Farm';
select * from College;
update College set cName = 'Standford' where cName = 'The Farm';
select * from College;

select * from Apply;
delete from College where cName = 'Standford';
delete from Apply where cName = 'Standford';

/**************************************************************
  TRIGGER CHAINING
  When number of applicants exceeds 10, label College as 'Done'
**************************************************************/

create trigger R6
after insert on Apply
for each row
when (select count(*) from Apply where cName = New.cName) > 10
begin
  update College set cName = cName || '-Done'
  where cName = New.cName;
end;

select count(*) from Apply where cName = 'Stanford';
select count(*) from Apply where cName = 'MIT';
select count(*) from Student where GPA > 3.3 and GPA <= 3.6;

insert into Student select * from Student;
select * from College;
select * from Apply;

select count(*) from Apply where cName = 'Stanford';
select count(*) from Student where GPA > 3.3 and GPA <= 3.6;

insert into Student select * from Student;
select * from College;
select * from Apply;

/**************************************************************
  ENFORCING CONSTRAINTS + MULTIPLE TRIGGERS ON ONE EVENT
  Cannot insert student with sizeHS < 100 or sizeHS > 5000
**************************************************************/

delete from Student;
delete from Apply;

create trigger R7
before insert on Student
for each row
when New.sizeHS < 100 or New.sizeHS > 5000
begin
  select raise(ignore);
end;

insert into Student values ('444', 'Nancy', 3.5, 500);
insert into Student values ('555', 'Otis', 3.5, 50);
insert into Student values ('666', 'Peter', 3.5, 8000);
select * from Student;
select * from Apply;

drop trigger R7;

create trigger R7
after insert on Student
for each row
when New.sizeHS < 100 or New.sizeHS > 5000
begin
  delete from Student where sID = New.sID;
end;

insert into Student values ('777', 'Quincy', 3.5, 1000);
insert into Student values ('888', 'Rita', 3.5, 10000);
select * from Student;
select * from Apply;

drop trigger R1;
drop trigger R2;
drop trigger R3;
drop trigger R4;
drop trigger R5;
drop trigger R6;
drop trigger R7;
delete from Student;
delete from Apply;

/**************************************************************
  'REALISTIC' MORE COMPLEX TRIGGER
  Automatically accept to Berkeley students with high GPAs
   from large high schools
**************************************************************/

create trigger AutoAccept
after insert on Apply
for each row
when (New.cName = 'Berkeley' and
      3.7 < (select GPA from Student where sID = New.sID) and
      1200 < (select sizeHS from Student where sID = New.sID))
begin
  update Apply
  set decision = 'Y'
  where sID = New.sID
  and cName = New.cName;
end;

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.9, 1500);

insert into Apply values (123, 'Berkeley', 'CS', null);
insert into Apply values (234, 'Berkeley', 'CS', null);
insert into Apply values (234, 'Stanford', 'CS', null);
select * from Apply;

drop trigger AutoAccept;
<repopulate database>

/**************************************************************
  'REALISTIC' MORE COMPLEX TRIGGER
  When enrollment goes from below 16000 to above 16000, remove
    'EE' applications and set all accepts to 'U' (undecided)
**************************************************************/

create trigger TooMany
after update of enrollment on College
for each row
when (Old.enrollment <= 16000 and New.enrollment > 16000)
begin
  delete from Apply
    where cName = New.cName and major = 'EE';
  update Apply
    set decision = 'U'
    where cName = New.cName
    and decision = 'Y';
end;

select * from Apply;
select * from College;
update College set enrollment = enrollment + 2000;
select * from Apply;
