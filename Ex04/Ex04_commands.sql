REM 1. Create a view named Blue_Flavor, which display the product details (product id,
REM    food, price) of Blueberry flavor.

create view Blue_flavor as (
select pid, food, price 
from products
where flavor = 'Blueberry');

select * from Blue_flavor;
select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'BLUE_FLAVOR';

REM : Checking whether it is upadteble or not
insert into products values('74-ABC-7U','Blueberry','Icecream',2.34);
select * from Blue_flavor;

update Blue_flavor
set price = price+2
where food = 'Tart'

REM : upadte successful
select * from Blue_flavor;

delete from Blue_flavor 
where food = 'Tart';



REM 2. Create a view named Cheap_Food, which display the details (product id, flavor,
REM    food, price) of products with price lesser than $1. Ensure that, the price of these
REM    food(s) should never rise above $1 through view.
	   

create view cheap_food as ( 
select pid, flavor, food, price 
from products 
where price < 1) 
with check option; 

select * from products values('88-DFG-9I','Mango','Pie',0.98)

insert into cheap_food values('74-AC-7U','Apple','icecream',1);
insert into cheap_food values('74-AC-7U','Apple','icecream',0.99);

select * from cheap_food;

update cheap_food 
set price = price+2 
where food = 'icecream';

update cheap_food 
set price = price-0.5 
where food = 'icecream';


select * from cheap_food;

delete from cheap_food 
where food = 'Cookie';

delete from cheap_food 
where food = 'icecream';

select * from cheap_food;

select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'CHEAP_FOOD';


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
select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'HOT_FOOD';

update hot_food 
set quantity = quantity+2 
where item = '46-11';

REM 4. Create a view named Pie_Food that will display the details (customer lname, flavor,
REM    receipt number and date, ordinal) who had ordered the Pie food with receipt details.
create view pie_food as (  
select c.lname,p.flavor,r.rno,r.r_date, i.ordinal 
from customers c join receipts r on r.cid = c.cid join item_list i on i.rno = r.rno join products p on p.pid = i.item   
where p.food = 'Pie');

select * from pie_food;
select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'PIE_FOOD';

REM 5. Create a view Cheap_View from Cheap_Food that shows only the product id, flavor
REM    and food.

create view cheap_view as (
select pid , flavor, food
from cheap_food );

select * from cheap_view;


REM 6. Create a sequence named Ordinal_No_Seq which generates the ordinal number
REM    starting from 1, increment by 1, to a maximum of 10. Include the options of cycle,
REM    cache and order. Use this sequence to populate the item_list table for a new order.

insert into receipts values(00001, '31-Oct-2007', 17);
create sequence s
start with 1
increment by 1
minvalue 1
maxvalue 10
nocycle
order
cache 10;

insert into item_list values(00001, s.nextval,  '45-CO');
insert into item_list values(00001, s.nextval,  '90-APR-PF');
insert into item_list values(00001, s.nextval,  '50-CHS');
insert into item_list values(00001, s.nextval,  '50-APP');
insert into item_list values(00001, s.nextval,  '70-R');

select * from receipts 
where rno = 00001;

select * from item_list
where rno = 00001
order by rno;

REM 7. Create a synonym named Product_details for the item_list relation. Perform the
REM    DML operations on it.

create synonym product_details 
for item_list;

select *
from product_details
where item =  '90-APR-PF';

REM 8. Drop all the above created database objects.

drop view Blue_flavor;
drop view cheap_view;
drop view hot_food;
drop view pie_food;
drop view cheap_food;
drop sequence s;
drop synonym product_details;
delete from item_list where rno = 00001;
delete from receipts where rno = 00001;
