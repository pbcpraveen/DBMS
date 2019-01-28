REM 1. Create a view named Blue_Flavor, which display the product details (product id,
REM    food, price) of Blueberry flavor.

create view Blue_flavor as (
select pid, food, price 
from products
where flavor = 'Blueberry');

REM 2. Create a view named Cheap_Food, which display the details (product id, flavor,
REM    food, price) of products with price lesser than $1. Ensure that, the price of these
REM    food(s) should never rise above $1 through view.
	   

create view cheap_food as (
select pid, flavor, food, price
from products
where price < 1)
with check option;

select * from cheap_food;

REM 3. Create a view called Hot_Food that show the product id and its quantity where the
       same product is ordered more than once in the same receipt.
create view hot_food as (
select i.item, count(*) as quantity
from item_list i join receipts r on i.rno = r.rno
where i.item = any(select i2.item 
                   from item_list i2 
				   where i2.rno=i.rno
				   group by i2.item
				   having count(*)>1)
group by i.item);

REM 4. Create a view named Pie_Food that will display the details (customer lname, flavor,
REM    receipt number and date, ordinal) who had ordered the Pie food with receipt details.
create view Pie_Food as (
select c.lname,p.flavor,r.rno,r.r_date, i.ordinal
from customers c join receipts r on r.cid = c.cid join item_list i on i.rno = r.rno join products p on p.pid = i.item
where p.food = 'Pie');

select * from Pie_Food;

REM 5. Create a view Cheap_View from Cheap_Food that shows only the product id, flavor
REM    and food.

create view Cheap_View as (
select pid , flavor, food
from cheap_food );

select * from Cheap_View;


REM 6. Create a sequence named Ordinal_No_Seq which generates the ordinal number
REM    starting from 1, increment by 1, to a maximum of 10. Include the options of cycle,
REM    cache and order. Use this sequence to populate the item_list table for a new order.
drop sequence s;

insert into receipts values(00001, '31-Oct-2007', 17);
create sequence s
start with 1
increment by 1
minvalue 1
maxvalue 10
nocycle;

insert into item_list values(00001, s.nextval,  '45-CO');
insert into item_list values(00001, s.nextval,  '90-APR-PF');
insert into item_list values(00001, s.nextval,  '50-CHS');
insert into item_list values(00001, s.nextval,  '50-APP');
insert into item_list values(00001, s.nextval,  '70-R');

select * from receipts 
where rno = 00001;

select * from item _list 
where rno = 00001
order by rno;

REM 7. Create a synonym named Product_details for the item_list relation. Perform the
REM    DML operations on it.

drop synonym product_details;
create synonym product_details 
for item_list;

select *
from product_details
where item =  '90-APR-PF';

REM 8. Drop all the above created database objects.

drop view Blue_flavor;
drop view cheap_food;
drop view hot_food;
drop view pie_food;
drop view cheap_food;
drop sequence s;
drop synonym product_details;