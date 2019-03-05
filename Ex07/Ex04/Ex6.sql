REM 4. Write a stored function to display the customer name who ordered maximum for the 
EEM given food and flavor.

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
having count(*)=m;
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
dbms_output.put_line('name:    '||name);
end;
/









EX07

REM 1.

create or replace trigger sampletrigger
before insert or update on products 
for each row
declare
p int;
DuplicateException EXCEPTION;
begin
select count(*) into p from products
where food = :new.food and flavor = :new.flavor
group by pid;
if p>0 then
    raise DuplicateException;
else 
    dbms_output.put_line(:new.pid||' inserted successfully');
end if;
EXCEPTION
when DuplicateException then
    dbms_output.put_line('Dupliacte entries found');
	delete from products where pid = :new.pid;
end;
/






