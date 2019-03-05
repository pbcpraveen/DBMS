
rem 1. The combination of Flavor and Food determines the product id. Hence, while
rem inserting a new instance into the Products relation, ensure that the same combination
rem of Flavor and Food is not already available.
savepoint A;
create or replace trigger unique_food
before insert on products
for each row
declare
  p products%rowtype;
  cursor c1 is
  select * from products
  where food = :new.food and flavor = :new.flavor;
begin
  open c1;
  fetch c1 into p;
  if c1%rowcount>0 then
      RAISE_APPLICATION_ERROR( -20001, 'The Combination of Food and Flavor already exists' );
  else
      
      dbms_output.put_line('Inserted');
  end if;
  close c1;
end;
/
insert into products values('TT-03','Apricot','Tart',3.75);
insert into products values('TT-03','Grapes','Tart',3.75);



REM 2. While entering an item into the item_list relation, update the amount in Receipts with 
REM the total amount for that receipt number.
alter table Receipts add amount number(5,2);
update receipts r set amount = (select sum(p.price) from item_list i join products p on i.item = p.pid
                                 where i.rno = r.rno);
create or replace trigger amount_update
after insert on item_list for each row
declare
iprice products.price%type;
begin
select price into iprice from products where pid = :new.item;
update Receipts set amount = amount + iprice where rno = :new.rno;
end;
/

select * from Receipts where rno = 77406;
insert into item_list values(77406, 8, '70-MAR');
select * from Receipts where rno = 77406;
alter table receipts drop column amount;

REM 3. Implement the following constraints for Item_list relation:
REM a. A receipt can contain a maximum of five items only.
REM b. A receipt should not allow an item to be purchased more than thrice.

create or replace trigger item_constraint
before insert or update on item_list for each row
begin
if :new.ordinal > 5 then
raise_application_error(-20002,'Error: Has more than 5 items!');
end if;
end;
/ 

insert into item_list values(52761, 6, '70-TU');

create or replace trigger thrice_constraint
before insert or update on item_list for each row
declare
cursor c2 is select rno, item, count(*) as qty from item_list
where item = :new.item and rno = :new.rno
group by item, rno;
q int;
r item_list.rno%type;
i item_list.item%type;
begin
open c2;
fetch c2 into r, i, q;
if c2%FOUND then
if q >= 3 then
raise_application_error(-20003,'Error: Item count > 3!');
end if;
end if;
end;
/

insert into item_list values(55944, 6,  '50-CHS');
insert into item_list values(84665, 2,  '90-BER-11');
insert into item_list values(84665, 3,  '90-BER-11');
