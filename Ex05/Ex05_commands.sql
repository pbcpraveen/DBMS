REM 1. Check whether the given combination of food and flavor is available. If any one or
REM    both are not available, display the relevant message.
set serveroutput on;

declare
fl products.flavor%type;
fo products.food%type;

begin	
	fl := '&flavor';
	fo := '&food';
	update products p set p.price = p.price+0 
	where p.food = fo and p.flavor = fl;
	if SQL%rowcount>0 then
		dbms_output.put_line(sql%rowcount||' products found of given combination');
		return;
	end if;
	update products p set p.price = p.price+0 
	where p.flavor = fl;
    if SQL%rowcount>0 then
		dbms_output.put_line('only flavor is found');
		return;
		end if;
	update products p set p.price = p.price+0
	where p.food = fo;
	if SQL%rowcount>0  then
		dbms_output.put_line('only food is found');
		return;
		end if;
	dbms_output.put_line('neither food nor flavor is found');

end;
/
REM 2. On a given date, find the number of items sold (Use Implicit cursor).

declare
date_search receipts.r_date%type;
begin
    
	date_search := '&date_search';
	update item_list i
	set i.ordinal = i.ordinal+0
	where i.rno in (select r.rno from receipts r
	                            where r.r_date = date_search);
	if SQL%found and SQL%rowcount >0 then
		dbms_output.put_line('No. of items sold on '||date_search||' is/are:'||SQL%rowcount);
	else
		dbms_output.put_line('No items sold');
	end if;
end;
/

REM 3. An user desired to buy the product with the specific price. Ask the user for a price,
REM find the food item(s) that is equal or closest to the desired price. Print the product
REM number, food type, flavor and price. Also print the number of items that is equal or
REM closest to the desired price.


declare
inputprice products.price%type;
CURSOR c1 is select * from products 
where abs(price-inputprice) in (select min(abs(p.price-inputprice))
                              from products p
							  ) ;
counts integer;
ex_product products%rowtype;
begin
inputprice := &inputprice;
open c1;
select count(*) into counts
from (select * from products 
where abs(price - inputprice) in (select min(abs(p.price-inputprice))
                              from products p));
for count in 1..counts loop
            fetch c1 into ex_product.pid,ex_product.flavor,ex_product.food,ex_product.price;
            dbms_output.put_line(ex_product.pid||'  '||ex_product.flavor||'  '||ex_product.food||' '||ex_product.price );
    end loop;
end;
/
REM 4. Display the customer name along with the details of item and its quantity ordered for
REM    the given order number. Also calculate the total quantity ordered as shown below:


declare 
cust_name1 customers.lname%type;
cust_name2 customers.fname%type;
qty integer;
rec_sel receipts.rno%type;
counts integer;
food_sel products.food%type;
flavor_sel products.flavor%type;
qtys integer;
cursor c1 is select food, flavor, count(*) as qty 
from products p join item_list i on i.item = p.pid
where i.rno = rec_sel 
group by (p.food,p.flavor);
cursor c2 is select fname,lname from customers c join receipts r on r.cid = c.cid
where rno = rec_sel ;

begin
rec_sel := &rec_sel;
select count(count(*)) into counts from products p join item_list i on i.item = p.pid 
where i.rno = rec_sel
group by (p.food,p.flavor);
select sum(count(*)) into qty from products p join item_list i on i.item = p.pid 
where i.rno = rec_sel
group by (p.food,p.flavor);
open c1;
open c2;
fetch c2 into cust_name1,cust_name2;
dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2); 
dbms_output.put_line('FOOD FLAVOR QUANTITY');
dbms_output.put_line('------------------------------------------');
for count in 1..counts loop
            fetch c1 into food_sel,flavor_sel,qtys;
            dbms_output.put_line(flavor_sel||' '||food_sel||' '||qtys);
    end loop;
	
dbms_output.put_line('------------------------------------------');
dbms_output.put_line('Total Quantity='||qty);
end;
/
