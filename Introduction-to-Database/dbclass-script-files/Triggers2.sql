/**************************************************************
  TRIGGERS - PART 2
  Designed for SQLite
  Works for Postgres but with post-statement activation,
    requires trigger actions specified as stored procedures
  MySQL doesn't support WHEN, UPDATE event with attributes,
    multiple triggers on same event, trigger chaining
**************************************************************/

create table T1(A int);
create table T2(A int);
create table T3(A int);
create table T4(A int);

/**************************************************************
  SELF-TRIGGERING
**************************************************************/

create trigger R1
after insert on T1
for each row
begin
  insert into T1 values (New.A+1);
end;

insert into T1 values (1);
select * from T1;

pragma recursive_triggers = on;

insert into T1 values (1);

delete from T1;
drop trigger R1;

create trigger R1
after insert on T1
for each row
when (select count(*) from T1) < 10
begin
  insert into T1 values (New.A+1);
end;

insert into T1 values (1);
select * from T1;

/**************************************************************
  CYCLES
**************************************************************/

delete from T1;
drop trigger R1;
pragma recursive_triggers = off;

create trigger R1
after insert on T1
for each row
begin
  insert into T2 values (New.A+1);
end;

create trigger R2
after insert on T2
for each row
begin
  insert into T3 values (New.A+1);
end;

create trigger R3
after insert on T3
for each row
begin
  insert into T1 values (New.A+1);
end;

insert into T1 values (1);
select * from T1;
select * from T2;
select * from T3;

pragma recursive_triggers = on;

delete from T1;
delete from T2;
delete from T3;

drop trigger R3;

create trigger R3
after insert on T3
for each row
when (select count(*) from T1) < 100
begin
  insert into T1 values (New.A+1);
end;

insert into T1 values (1);
select * from T1;
select * from T2;
select * from T3;

/**************************************************************
  CONFLICTING TRIGGERS
**************************************************************/

drop trigger R1;
drop trigger R2;
drop trigger R3;
delete from T1;
delete from T2;
delete from T3;

create trigger R1
after insert on T1
for each row
begin
  update T1 set A = 2;
end;

create trigger R2
after insert on T1
for each row
when exists (select * from T1 where A = 2)
begin
  update T1 set A = 3;
end;

insert into T1 values (1);
select * from T1;

drop trigger R1;
drop trigger R2;
delete from T1;

create trigger R2
after insert on T1
for each row
when exists (select * from T1 where A = 2)
begin
  update T1 set A = 3;
end;

create trigger R1
after insert on T1
for each row
begin
  update T1 set A = 2;
end;

insert into T1 values (1);
select * from T1;

/**************************************************************
  NESTED INVOCATIONS
**************************************************************/

drop trigger R1;
drop trigger R2;
delete from T1;

create trigger R1
after insert on T1
for each row
begin
  insert into T2 values (1);
  insert into T3 values (1);
end;

create trigger R2
after insert on T2
for each row
begin
  insert into T3 values (2);
  insert into T4 values (2);
end;

create trigger R3
after insert on T3
for each row
begin
  insert into T4 values (3);
end;

insert into T1 values (0);
select * from T1;
select * from T2;
select * from T3;
select * from T4;

/**************************************************************
  ROW-LEVEL IMMEDIATE ACTIVATION
  SQLite and MySQL non-standard
**************************************************************/

drop trigger R1;
drop trigger R2;
drop trigger R3;
delete from T1;
drop table T2;
create table T2 (a float);

insert into T1 values (1);
insert into T1 values (1);
insert into T1 values (1);
insert into T1 values (1);

create trigger R1
after insert on T1
for each row
begin
  insert into T2 select avg(A) from T1;
end;

insert into T1 select A+1 from T1;
select * from T1;
select * from T2;

/**************************************************************
  CLEANUP
**************************************************************/

delete from T1;
delete from T2;
delete from T3;
delete from T4;

drop table T1;
drop table T2;
drop table T3;
drop table T4;
