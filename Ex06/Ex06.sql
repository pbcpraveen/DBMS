REM 1. For the given receipt number, calculate the Discount as follows: 
REM For total amount > $10 and total amount < $25:  Discount=5% 
REM For total amount > $25 and total amount < $50:  Discount=10% 
REM For total amount > $50: Discount=20% 
REM Calculate the amount (after the discount) and update the same in Receipts table. 
REM Print the receipt as shown below: 
REM ************************************************************
REM Receipt Number:13355 Customer Name: TOUSSAND SHARRON
REM Receipt Date :19­Oct­2007 
REM ************************************************************
REM Sno Flavor  Food Price
REM 1. Opera Cake 15.95
REM 2. Lemon  Cookie   0.79 
REM 3.  Napoleon  Cake  13.49
REM ­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
REM Total =  $ 30.23
REM ­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
REM Total Amount  :$ 30.23 
REM Discount(10%) :$  3.02
REM ­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
REM Amount to be paid  :$ 27.21
REM ************************************************************
REM Great Offers! Discount up to 25% on DIWALI Festival Day... 
REM ************************************************************

create or replace procedure discount(cp IN products.price%type, dis OUT products.price%type,dp OUT products.price%type,sp OUT products.price%type) is
begin
dis := 0;
dp := 0;
if cp>10 and cp<25 then 
dis := (5*cp)/100.00;
dp := 5;
else 
if cp>25 and cp<50 then
dis := (10*cp)/100.00;
dp := 10;
else 
if cp>50 then
dis := (20*cp)/100.00;
dp := 20;
end if;
end if;
end if;
sp := cp -dis;
end;
/
declare
sel receipts.rno%type;
billdate receipts.r_date%type;
custlname customers.lname%type;
custfname customers.fname%type;
cursor c1 is select p.food ,p.flavor,sum(p.price)
from products p join item_list i on i.item=p.pid
where i.rno = sel
group by p.food ,p.flavor;
cp  products.price%type;
d products.price%type;
dp  products.price%type;
sp  products.price%type;
counts integer;
food_sel products.food%type;
flavor_sel products.flavor%type;
lprice products.price%type;
begin
sel := &receipt;
select sum(p.price) into cp from products p join item_list i on p.pid = i.item
where i.rno = sel;
select count(count(*)) into counts from products p join item_list i on p.pid = i.item
where i.rno = sel
group by p.food,p.flavor;
open c1;
select c.lname,c.fname,r.r_date into custfname,custlname,billdate from receipts r join customers c on c.cid = r.cid
where r.rno=sel;


dbms_output.put_line('Customer name: '||custfname||' '||custlname);
dbms_output.put_line('Receipt No.: '||sel);
dbms_output.put_line('Receipt date: '||billdate);
dbms_output.put_line('******************************************');
dbms_output.put_line('SNO    FOOD           FLAVOR         ');
dbms_output.put_line('******************************************');
for a in 1..counts loop
            fetch c1 into food_sel,flavor_sel,lprice;
            dbms_output.put_line(' '||a||' '||flavor_sel||' '||food_sel);
end loop;
discount(cp,d,dp,sp);
dbms_output.put_line('******************************************');
dbms_output.put_line('Total = $ '||cp);
dbms_output.put_line('Discount ('||dp||'%) = $ '||d);
dbms_output.put_line('Grand Total = $ '||sp);
dbms_output.put_line('******************************************');
dbms_output.put_line('Upto 20% discount available!');
dbms_output.put_line('******************************************');
end;
/

REM 2. Ask the user for the budget and his/her preferred food type. You recommend the best 
REM item(s) within the planned budget for the given food type. The best item is 
REM determined by the maximum ordered product among many customers for the given 
REM food type.
REM Print the recommended product that suits your budget as below:
REM ************************************************************
REM Budget: $10 Food type: Meringue
REM ************************************************************
REM Item ID Flavor Food Price
REM 70­M­CH­DZ Chocolate Meringue 1.25
REM 70­M­VA­SM­DZ Vanilla Meringue 1.15
REM ­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­ 
REM 70­M­CH­DZ with Chocolate flavor is the best item in Meringue type!
REM REM You are entitled to purchase 8 Meringue chocolates for the given 
REM budget !!!
REM *************************************************************

create or replace procedure calcount(budget in products.price%type, val in products.price%type, qty out integer) is
begin
if val <= budget then 
	qty := budget/val;
else 
	qty := 0;
end if;
end;
/
declare 
budget products.price%type;
val products.price%type;
pfood products.food%type;
qty INTEGER(3);
psel products.pid%type;
psample products%rowtype;
cursor c1 is select p.pid,p.food,p.flavor,p.price 
from products p join item_list i on p.pid = i.item
where p.price <= budget and p.food = pfood
group by p.pid,p.food,p.flavor,p.price
order by count(*) desc;
cts integer;
fsel products.flavor%type;
begin
budget := &budget;
pfood := '&food';

open c1;
begin
select p1.pid,p1.price,p1.flavor into psel,val,fsel
from products p1 join item_list i on p1.pid = i.item
where p1.price <= budget and p1.food = pfood
group by p1.pid,p1.food,p1.flavor,p1.price
having count(*)>=ALL(select count(*) 
                     from products p2 join item_list i on p2.pid = i.item
                     where p2.price <= budget and p2.food = pfood
                     group by p2.pid,p2.food,p2.flavor,p2.price);
EXCEPTION 
when no_data_found then
dbms_output.put_line('No Recomendations found');
return;
end;

select count(count(*)) into cts  from products p join item_list i on p.pid = i.item
where p.price <= budget and p.food = pfood
group by p.pid,p.food,p.flavor,p.price;
dbms_output.put_line('******************************************');

dbms_output.put_line('SNO  PID        FOOD          FLAVOR         PRICE');	
dbms_output.put_line('******************************************');
	
for a in 1..cts loop
			fetch c1 into psample;
			dbms_output.put_line(a||' '||psample.pid||'	'||psample.food||' '||psample.flavor||'	'||psample.price);
end loop;
dbms_output.put_line('******************************************');

calcount(budget,val,qty);
dbms_output.put_line(psel||' with '||fsel||' flavor is the best item in '||pfood||' type!');

dbms_output.put_line(' You are entitled to purchase '||qty||' '||pfood||' '||fsel||' for the given budget !!!');
dbms_output.put_line('******************************************');

end;
/


REM 3. Take a receipt number and item as arguments, and insert this information into the 
REM Item list. However, if there is already a receipt with that receipt number, then keep 
REM adding 1 to the maximum ordinal number. Else before inserting into the Item list 
REM with ordinal as 1, ask the user to give the customer name who placed the order and 
REM insert this information into the Receipts.

create or replace procedure insertitem(rec IN receipts.rno%type,ordi IN item_list.ordinal%type,prodid IN products.pid%type) is
begin
insert into item_list values(rec,ordi,prodid);
end;
/

create or replace procedure insertreceipts(rec IN receipts.rno%type,rdt IN receipts.r_date%type,rcid IN receipts.cid%type) is
begin
insert into receipts values(rec,rdt,rcid);
end;
/

create or replace procedure findcid(cfname IN customers.fname%type,clname IN customers.lname%type, fcid OUT customers.cid%type) is
begin
begin
select c.cid into fcid 
from customers c 
where c.fname= cfname and c.lname= clname;
EXCEPTION 
WHEN no_data_found then
 DBMS_OUTPUT.PUT_LINE('customer ID not found');
 fcid := 0;
end;
end;
/
declare 
cfname customers.fname%type;
clname customers.lname%type;
fcid customers.cid%type;
rec receipts.rno%type;
ordi item_list.ordinal%type;
prodid products.pid%type;
rdt receipts.r_date%type;
item_row item_list%rowtype;
cursor c1 is 
select * 
from item_list i 
where i.rno = rec
order by i.ordinal desc;
maxordi item_list.ordinal%type;
begin
rec := &RECEIPT;
prodid := '&product';
open c1;
fetch c1 into item_row;
if c1%rowcount>0 then 
    begin
	ordi := item_row.ordinal + 1;
	insertitem(rec,ordi,prodid);
	return;
	end;
else
	begin
	
	dbms_output.put_line('Receipt number not found!!!');
	dbms_output.put_line('CREATE A RECEIPT:');
	cfname := '&firstname';
	clname := '&lastname';
	rdt := '&date';
	findcid(cfname,clname,fcid);
	insertreceipts(rec,rdt,fcid);
	ordi := 1;
	insertitem(rec,ordi,prodid);
	return;
	end;
end if;
end;
/


REM 4. Write a stored function to display the customer name who ordered 
REM maximum for the given food and flavor.

create or replace function maxcustomer(p IN products.pid%type) return varchar2 as
c customers.cid%type;
m int;
n1 customers.fname%type;
n2 customers.lname%type;
name varchar2(40);
begin
select max(count(*)) into m from receipts r join item_list i on i.rno = r.rno
where i.item = p
group by r.cid;
select r.cid into c from receipts r join item_list i on i.rno = r.rno
where i.item = p
group by r.cid
having count(*) = m;
select c1.fname into n1 from customers c1 where c1.cid = c;
select c1.lname into n2 from customers c1 where c1.cid = c;
name := n1||n2;
return name;
end maxcustomer;
/

declare 
name varchar2(40);
p products.pid%type;
fo products.food%type;
fl products.flavor%type;
begin
fo:='&food';
fl:='&flavor';
select p1.pid into p from products p1 where p1.food = fo and p1.flavor = fl;
name := maxcustomer(p);
dbms_output.put_line('Name: '||name);
end;
/


REM 5. Implement Question (2) using stored function to return the amount to be paid and 
REM update the same, for the given receipt number. 
create or replace function discountfun(cp IN products.price%type, dis OUT products.price%type,dp OUT products.price%type) return products.price%type is
sp products.price%type;
begin
dis := 0;
dp := 0;
if cp>10 and cp<25 then 
dis := (5*cp)/100.00;
dp := 5;
else 
if cp>25 and cp<50 then
dis := (10*cp)/100.00;
dp := 10;
else 
if cp>50 then
dis := (20*cp)/100.00;
dp := 20;
end if;
end if;
end if;
sp := cp -dis;
return sp;
end;
/
declare
sel receipts.rno%type;
billdate receipts.r_date%type;
custlname customers.lname%type;
custfname customers.fname%type;
cursor c1 is select p.food,p.flavor,sum(p.price)
from products p join item_list i on i.item=p.pid
where i.rno = sel
group by p.food,p.flavor;
cp  products.price%type;
d products.price%type;
dp  products.price%type;
sp  products.price%type;
counts integer;
food_sel products.food%type;
flavor_sel products.flavor%type;
lprice products.price%type;
begin
sel := &receipt;
select sum(p.price) into cp from products p join item_list i on p.pid = i.item
where i.rno = sel;
select count(count(*)) into counts from products p join item_list i on p.pid = i.item
where i.rno = sel
group by p.food,p.flavor;
open c1;
select c.lname,c.fname,r.r_date into custfname,custlname,billdate from receipts r join customers c on c.cid = r.cid
where r.rno=sel;


dbms_output.put_line('Customer name: '||custfname||' '||custlname);
dbms_output.put_line('Receipt No.: '||sel);
dbms_output.put_line('Receipt date: '||billdate);
dbms_output.put_line('******************************************');
dbms_output.put_line('SNO FOOD           FLAVOR        PRICE');
dbms_output.put_line('******************************************');
for a in 1..counts loop
            fetch c1 into food_sel,flavor_sel,lprice;
            dbms_output.put_line(' '||a||' '||flavor_sel||' '||food_sel||' '||lprice);
end loop;
sp := discountfun(cp,d,dp);
dbms_output.put_line('******************************************');
dbms_output.put_line('Total = $ '||cp);
dbms_output.put_line('Discount ('||dp||'%) = $ '||d);
dbms_output.put_line('Grand Total = $ '||sp);
dbms_output.put_line('******************************************');
dbms_output.put_line('Upto 20% discount available!');
dbms_output.put_line('******************************************');
end;
/	

