SQL> @D:/Ex07_commands.sql
SQL> 
SQL> rem 1. The combination of Flavor and Food determines the product id. Hence, while
SQL> rem inserting a new instance into the Products relation, ensure that the same combination
SQL> rem of Flavor and Food is not already available.
SQL> savepoint A;

Savepoint created.

SQL> create or replace trigger unique_food
  2  before insert on products
  3  for each row
  4  declare
  5    p products%rowtype;
  6    cursor c1 is
  7    select * from products
  8    where food = :new.food and flavor = :new.flavor;
  9  begin
 10    open c1;
 11    fetch c1 into p;
 12    if c1%rowcount>0 then
 13  	   RAISE_APPLICATION_ERROR( -20001, 'The Combination of Food and Flavor already exists' );
 14    else
 15  
 16  	   dbms_output.put_line('Inserted');
 17    end if;
 18    close c1;
 19  end;
 20  /

Trigger created.

SQL> insert into products values('TT-03','Apricot','Tart',3.75);
insert into products values('TT-03','Apricot','Tart',3.75)
            *
ERROR at line 1:
ORA-20001: The Combination of Food and Flavor already exists 
ORA-06512: at "HR.UNIQUE_FOOD", line 10 
ORA-04088: error during execution of trigger 'HR.UNIQUE_FOOD' 


SQL> insert into products values('TT-03','Grapes','Tart',3.75);
Inserted                                                                        

1 row created.

SQL> 
SQL> 
SQL> 
SQL> REM 2. While entering an item into the item_list relation, update the amount in Receipts with
SQL> REM the total amount for that receipt number.
SQL> alter table Receipts add amount number(5,2);

Table altered.

SQL> update receipts r set amount = (select sum(p.price) from item_list i join products p on i.item = p.pid
  2  				      where i.rno = r.rno);

199 rows updated.

SQL> create or replace trigger amount_update
  2  after insert on item_list for each row
  3  declare
  4  iprice products.price%type;
  5  begin
  6  select price into iprice from products where pid = :new.item;
  7  update Receipts set amount = amount + iprice where rno = :new.rno;
  8  end;
  9  /

Trigger created.

SQL> 
SQL> select * from Receipts where rno = 77406;

       RNO R_DATE           CID     AMOUNT                                      
---------- --------- ---------- ----------                                      
     77406 09-OCT-07         13      23.25                                      

SQL> insert into item_list values(77406, 8, '70-MAR');

1 row created.

SQL> select * from Receipts where rno = 77406;

       RNO R_DATE           CID     AMOUNT                                      
---------- --------- ---------- ----------                                      
     77406 09-OCT-07         13       24.5                                      

SQL> alter table receipts drop column amount;

Table altered.

SQL> 
SQL> REM 3. Implement the following constraints for Item_list relation:
SQL> REM a. A receipt can contain a maximum of five items only.
SQL> REM b. A receipt should not allow an item to be purchased more than thrice.
SQL> 
SQL> create or replace trigger item_constraint
  2  before insert or update on item_list for each row
  3  begin
  4  if :new.ordinal > 5 then
  5  raise_application_error(-20002,'Error: Has more than 5 items!');
  6  end if;
  7  end;
  8  /

Trigger created.

SQL>
SQL> create or replace trigger thrice_constraint
  2  before insert or update on item_list for each row
  3  declare
  4  cursor c2 is select rno, item, count(*) as qty from item_list
  5  where item = :new.item and rno = :new.rno
  6  group by item, rno;
  7  q int;
  8  r item_list.rno%type;
  9  i item_list.item%type;
 10  begin
 11  open c2;
 12  fetch c2 into r, i, q;
 13  if c2%FOUND then
 14  if q >= 3 then
 15  raise_application_error(-20003,'Error: Item count > 3!');
 16  end if;
 17  end if;
 18  end;
 19  /

Trigger created.

SQL>
SQL> insert into item_list values(55944, 6,  '50-CHS');
insert into item_list values(55944, 6,  '50-CHS')
            *
ERROR at line 1:
ORA-20002: Error: Has more than 5 items!
ORA-06512: at "HR.ITEM_CONSTRAINT", line 3
ORA-04088: error during execution of trigger 'HR.ITEM_CONSTRAINT'


SQL> insert into item_list values(84665, 2,  '90-BER-11');

1 row created.

SQL> insert into item_list values(84665, 3,  '90-BER-11');

1 row created.

SQL> insert into item_list values(84665, 4,  '90-BER-11');
insert into item_list values(84665, 4,  '90-BER-11')
            *
ERROR at line 1:
ORA-20003: Error: Item count > 3!
ORA-06512: at "HR.THRICE_CONSTRAINT", line 13
ORA-04088: error during execution of trigger 'HR.THRICE_CONSTRAINT'


SQL>

SQL> spool off;
