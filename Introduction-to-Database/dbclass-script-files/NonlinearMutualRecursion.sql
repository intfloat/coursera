/**************************************************************
  NONLINEAR AND MUTUAL RECURSION
  Designed for Postgres (but not supported)
  SQLite and MySQL don't support WITH RECURSIVE
**************************************************************/

/**************************************************************
  EXAMPLE 1: Ancestors (nonlinear recursion)
  Find all of Mary's ancestors
**************************************************************/

/*** Original formulation ***/

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

/*** Nonlinear formulation ***/

with recursive
  Ancestor(a,d) as (select parent as a, child as d from ParentOf
                    union
                    select A1.a, A2.d
                    from Ancestor A1, Ancestor A2
                    where A1.d = A2.a)
select a from Ancestor where d = 'Mary';

/**************************************************************
  EXAMPLE 2: Hubs and Authorities (mutual recursion)
  Find all hub nodes
**************************************************************/

create table Link (src int, dest int);
create table HubStart (node int);
create table AuthStart (node int);

with recursive
  Hub(node) as (select node from HubStart
                union
                select src as node from Link L
                where 3 <= (select count(*) from Auth A
                            where L.dest = A.node)),
   Auth(node) as (select node from AuthStart
                  union
                  select dest as node from Link L
                  where 3 <= (select count(*) from Hub H
                              where L.src = H.node))
select * from Hub;

/*** When nodes can't be both a Hub and Authority; nondeterministic ***/

with recursive
  Hub(node) as (select node from HubStart
                union
                select src as node from Link L
                where 3 <= (select count(*) from Auth A
                            where L.dest = A.node)
                and src not in (select node from Auth)),
  Auth(node) as (select node from AuthStart
                 union
                 select dest as node from Link L
                 where 3 <= (select count(*) from Hub H
                             where L.src = H.node)
                 and dest not in (select node from Hub))
select * from Hub;

/**************************************************************
  EXAMPLE 2: Recursion with aggregations
  Find all hub nodes
**************************************************************/

create table P(x int);
insert into P values (1);
insert into P values (2);

with recursive
  R(x) as (select x from P
           union
           select sum(x) from R)
select * from R;

/**************************************************************
   CLEANUP
**************************************************************/

drop table ParentOf;
drop table HubStart;
drop table AuthStart;
drop table Link;
drop table P;
