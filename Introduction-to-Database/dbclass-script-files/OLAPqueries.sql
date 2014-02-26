/**************************************************************
  OLAP demo queries
  Works for MySQL (with kludge for CUBE)
  SQLite and Postgres don't support ROLLUP or CUBE
**************************************************************/

/**************************************************************
  Full star join
**************************************************************/

select *
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID and F.itemID = I.itemID and F.custID = C.custID;

/**************************************************************
  Star join with selections and projections
  All inexpensive Tshirts sold in California to young people
**************************************************************/

select S.city, I.color, C.cName, F.price
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID and F.itemID = I.itemID and F.custID = C.custID
and S.state = 'CA' and I.category = 'Tshirt' and C.age < 22 and F.price < 25;

/**************************************************************
  Grouping and aggregation over fact table
  Total sales by store and customer
**************************************************************/

select storeID, custID, sum(price)
from Sales
group by storeID, custID;

/**************************************************************
  Drill-down
  Total sales by store, item, and customer
**************************************************************/

select storeID, itemID, custID, sum(price)
from Sales
group by storeID, itemID, custID;

/**************************************************************
  "Slice"
  Total sales by store, item, and customer for Washington stores only
**************************************************************/

select F.storeID, itemID, custID, sum(price)
from Sales F, Store S
where F.storeID = S.storeID
and state = 'WA'
group by F.storeID, itemID, custID;

/**************************************************************
  "Dice"
  Total sales by store, item, and customer for Washington stores
    and red items only
**************************************************************/

select F.storeID, I.itemID, custID, sum(price)
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
and state = 'WA' and color = 'red'
group by F.storeID, I.itemID, custID;

/**************************************************************
  Roll-up
  Total sales by item
**************************************************************/

/*** Back to detailed query, then roll-up ***/

select storeID, itemID, custID, sum(price)
from Sales
group by storeID, itemID, custID;

select itemID, sum(price)
from Sales
group by itemID;

/**************************************************************
  Grouping and aggregation using non-dimension attributes
  Total sales by state and category
**************************************************************/

select state, category, sum(price)
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
group by state, category;

/**************************************************************
  Drill-down
  Total sales by state, county, and category
**************************************************************/

select state, county, category, sum(price)
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
group by state, county, category;

/**************************************************************
  Drill-down even further
  Total sales by state, county, category, and gender
**************************************************************/

select state, county, category, gender, sum(price)
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID and F.itemID = I.itemID and F.custID = C.custID
group by state, county, category, gender;

/**************************************************************
  Roll-up
  Total sales by state and gender
**************************************************************/

select state, gender, sum(price)
from Sales F, Store S, Customer C
where F.storeID = S.storeID and F.custID = C.custID
group by state, gender;

/**************************************************************
  WITH CUBE
  Adds faces, edges, and corners of data cube
**************************************************************/

/*** Not supported ***/

select storeID, itemID, custID, sum(price)
from Sales
group by storeID, itemID, custID with cube;

/*** This query gives same result ***/

select storeID, itemID, custID, sum(price)
from Sales
group by storeID, itemID, custID with rollup
union
select storeID, itemID, custID, sum(price)
from Sales
group by itemID, custID, storeID with rollup
union
select storeID, itemID, custID, sum(price)
from Sales
group by custID, storeID, itemID with rollup;

/*** Double-check triple-NULL ***/

select sum(price) from Sales;

/**************************************************************
  CUBE as materialized view
**************************************************************/

create table Cube as
select storeID, itemID, custID, sum(price) as p
from Sales
group by storeID, itemID, custID with rollup
union
select storeID, itemID, custID, sum(price) as p
from Sales
group by itemID, custID, storeID with rollup
union
select storeID, itemID, custID, sum(price) as p
from Sales
group by custID, storeID, itemID with rollup;

/**************************************************************
  Query over CUBE view
  Total sales of blue items in California
**************************************************************/

/*** First without final sum, then with ***/

select C.*
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is null;

select sum(p)
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is null;

/*** Now on non-NULL portion of cube ***/

select C.*
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is not null;

select sum(p)
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is not null;

/*** On original Sales table ***/

select F.*
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
and state = 'CA' and color = 'blue' and F.custID is not null;

select sum(price)
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
and state = 'CA' and color = 'blue' and F.custID is not null;

/**************************************************************
  WITH CUBE on subset of grouping attributes
**************************************************************/

/*** Not supported ***/

select storeID, itemID, custID, sum(price)
from Sales F
group by storeID, itemID, custID with cube(storeID, custID);

/*** This query gives same result ***/

select * from
(select storeID, itemID, custID, sum(price)
 from Sales F
 group by itemID, storeID, custID with rollup) X
where X.itemID is not null
union
select * from
(select storeID, itemID, custID, sum(price)
 from Sales F
 group by itemID, custID, storeID with rollup) X
where X.itemID is not null and X.custID is not null;

/**************************************************************
  WITH ROLLUP
**************************************************************/

select storeID, itemID, custID, sum(price)
from Sales F
group by storeID, itemID, custID with rollup;

/**************************************************************
  WITH ROLLUP on hierarchical grouping attributes
  Total sales by state, county, city
**************************************************************/

select state, county, city, sum(price)
from Sales F, Store S
where F.storeID = S.storeID
group by state, county, city;

select state, county, city, sum(price)
from Sales F, Store S
where F.storeID = S.storeID
group by state, county, city with rollup;
