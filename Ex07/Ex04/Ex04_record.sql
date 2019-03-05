SQL> @Z:/Ex04_commands.sql
SQL> REM 1. Create a view named Blue_Flavor, which display the product details (product id,
SQL> REM    food, price) of Blueberry flavor.
SQL> 
SQL> create view Blue_flavor as (
  2  select pid, food, price
  3  from products
  4  where flavor = 'Blueberry');

View created.

SQL> 
SQL> select * from Blue_flavor;

PID             FOOD                      PRICE                                 
--------------- -------------------- ----------                                 
90-BLU-11       Tart                       3.25                                 
51-BLU          Danish                     1.15                                 

SQL> select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'BLUE_FLAVOR';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
PID                            YES                                              
FOOD                           YES                                              
PRICE                          YES                                              

SQL> 
SQL> REM : Checking whether it is upadteble or not
SQL> insert into products values('74-A99C-7U','Blueberry','Icecream',2.34);

1 row created.

SQL> select * from Blue_flavor;

PID             FOOD                      PRICE                                 
--------------- -------------------- ----------                                 
90-BLU-11       Tart                       3.25                                 
51-BLU          Danish                     1.15                                 
74-A99C-7U      Icecream                   2.34                                 

SQL> 
SQL> update Blue_flavor
  2  set price = price+2
  3  where food = 'Tart';

1 row updated.

SQL> 
SQL> REM : upadte successful
SQL> select * from Blue_flavor;

PID             FOOD                      PRICE                                 
--------------- -------------------- ----------                                 
90-BLU-11       Tart                       5.25                                 
51-BLU          Danish                     1.15                                 
74-A99C-7U      Icecream                   2.34                                 

SQL> 
SQL> delete from Blue_flavor
  2  where pid = '74-A99C-7U';

1 row deleted.

SQL> 
SQL> 
SQL> 
SQL> REM 2. Create a view named Cheap_Food, which display the details (product id, flavor,
SQL> REM    food, price) of products with price lesser than $1. Ensure that, the price of these
SQL> REM    food(s) should never rise above $1 through view.
SQL> 
SQL> 
SQL> create view cheap_food as (
  2  select pid, flavor, food, price
  3  from products
  4  where price < 1)
  5  with check option;

View created.

SQL> 
SQL> select * from products values('88-DFG-9I','Mango','Pie',0.98)
  2  
SQL> insert into cheap_food values('74-AC-7U','Apple','icecream',1);
insert into cheap_food values('74-AC-7U','Apple','icecream',1)
            *
ERROR at line 1:
ORA-01402: view WITH CHECK OPTION where-clause violation 


SQL> insert into cheap_food values('74-AC-7U','Apple','icecream',0.99);

1 row created.

SQL> 
SQL> select * from cheap_food;

PID             FLAVOR               FOOD                      PRICE            
--------------- -------------------- -------------------- ----------            
70-LEM          Lemon                Cookie                      .79            
70-W            Walnut               Cookie                      .79            
74-AC-7U        Apple                icecream                    .99            

SQL> 
SQL> update cheap_food
  2  set price = price+2
  3  where food = 'icecream';
update cheap_food
       *
ERROR at line 1:
ORA-01402: view WITH CHECK OPTION where-clause violation 


SQL> 
SQL> update cheap_food
  2  set price = price-0.5
  3  where food = 'icecream';

1 row updated.

SQL> 
SQL> 
SQL> select * from cheap_food;

PID             FLAVOR               FOOD                      PRICE            
--------------- -------------------- -------------------- ----------            
70-LEM          Lemon                Cookie                      .79            
70-W            Walnut               Cookie                      .79            
74-AC-7U        Apple                icecream                    .49            

SQL> 
SQL> 
SQL> delete from cheap_food
  2  where food = 'icecream';

1 row deleted.

SQL> 
SQL> select * from cheap_food;

PID             FLAVOR               FOOD                      PRICE            
--------------- -------------------- -------------------- ----------            
70-LEM          Lemon                Cookie                      .79            
70-W            Walnut               Cookie                      .79            

SQL> 
SQL> select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'CHEAP_FOOD';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
PID                            YES                                              
FLAVOR                         YES                                              
FOOD                           YES                                              
PRICE                          YES                                              

SQL> 
SQL> 
SQL> REM 3. Create a view called Hot_Food that show the product id and its quantity where the
SQL> REM    same product is ordered more than once in the same receipt.
SQL> create view hot_food as (
  2  select i.item, count(*) as quantity
  3  from item_list i join receipts r on i.rno = r.rno
  4  where i.item = any(select i2.item
  5  			from item_list i2
  6  					where i2.rno=i.rno
  7  					group by i2.item
  8  					having count(*)>1)
  9  group by i.item);

View created.

SQL> select * from hot_food;

ITEM                 COUNT                                                      
--------------- ----------                                                      
70-R                     2                                                      
90-APR-PF                2                                                      
50-APP                   2                                                      
51-ATW                   2                                                      
90-ALM-I                 2                                                      
90-BER-11                2                                                      
90-PEC-11                2                                                      
70-M-CH-DZ               2                                                      
46-11                    2                                                      
70-M-CH-DZ               2                                                      
90-CHR-11                2                                                      

ITEM                 COUNT                                                      
--------------- ----------                                                      
90-BLU-11                2                                                      
50-CHS                   2                                                      
70-M-CH-DZ               2                                                      
70-R                     2                                                      
90-APP-11                2                                                      
70-MAR                   2                                                      
50-APR                   2                                                      
51-BC                    2                                                      
50-ALM                   2                                                      

SQL> select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'HOT_FOOD';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
ITEM                           NO                                               
QUANTITY                       NO                                               

SQL> 
SQL>insert into item_list values(67341, 7,'51-BLU');

1 row created.
SQL> select * from hot_food;

ITEM                 COUNT                                                      
--------------- ----------                                                      
70-R                     2                                                      
90-APR-PF                2                                                      
50-APP                   2                                                      
51-ATW                   2                                                      
90-ALM-I                 2                                                      
90-BER-11                2                                                      
90-PEC-11                2                                                      
70-M-CH-DZ               2                                                      
46-11                    2                                                      
70-M-CH-DZ               2                                                      
90-CHR-11                2                                                      

ITEM                 COUNT                                                      
--------------- ----------                                                      
90-BLU-11                2                                                      
50-CHS                   2                                                      
70-M-CH-DZ               2                                                      
70-R                     2                                                      
90-APP-11                2                                                      
51-BLU                   2                                                      
50-APR                   2                                                      
51-BC                    2                                                      
50-ALM                   2          

SQL> 
SQL> delete from hot_food
  2  where item = 'A-B-c';
delete from hot_food
            *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 


SQL> 
SQL> update hot_food
  2  set quantity = quantity+2
  3  where item = '46-11';
update hot_food
       *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 


SQL> 
SQL> 
SQL> REM 4. Create a view named Pie_Food that will display the details (customer lname, flavor,
SQL> REM    receipt number and date, ordinal) who had ordered the Pie food with receipt details.
SQL> create view pie_food as (
  2  select c.lname,p.flavor,r.rno,r.r_date, i.ordinal
  3  from customers c join receipts r on r.cid = c.cid join item_list i on i.rno = r.rno join products p on p.pid = i.item
  4  where p.food = 'Pie');

View created.

SQL> 
SQL> select * from pie_food;

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
SOPKO                Apple                51991 17-OCT-07          1            
CRUZEN               Apple                44798 04-OCT-07          3            
SOPKO                Apple                29226 26-OCT-07          2            
LOGAN                Apple                66227 10-OCT-07          2            
HELING               Apple                53376 30-OCT-07          3            
LOGAN                Apple                39685 28-OCT-07          4            
HAFFERKAMP           Apple                50660 18-OCT-07          2            
CRUZEN               Apple                39109 02-OCT-07          1            
MESDAQ               Apple                98806 15-OCT-07          3            
SLINGLAND            Apple                47353 12-OCT-07          2            
SLINGLAND            Apple                87454 21-OCT-07          1            

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
ESPOSITA             Apple                48647 09-OCT-07          2            
ARNN                 Apple                11548 21-OCT-07          2    
        
SQL> select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'PIE_FOOD';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
LNAME                          NO                                               
FLAVOR                         NO                                               
RNO                            NO                                               
R_DATE                         NO                                               
ORDINAL                        YES                                              

SQL> 
SQL> insert into pie_food values('praven','berry',6483,'20-Jan-2005',7);
insert into pie_food values('praven','berry',6483,'20-Jan-2005',7)
*
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 

SQL> insert into Customers
  2  values(114,'Praveen','Kumar');

1 row created.

SQL> insert into item_list
  2  values(50660, 7,  '70-W');
  
1 row created.

SQL> delete from pie_food
  2  where flavor = 'berry';

SQL> select * from Pie_Food;

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
SOPKO                Apple                51991 17-OCT-07          1            
CRUZEN               Apple                44798 04-OCT-07          3            
SOPKO                Apple                29226 26-OCT-07          2            
LOGAN                Apple                66227 10-OCT-07          2            
HELING               Apple                53376 30-OCT-07          3            
LOGAN                Apple                39685 28-OCT-07          4            
HAFFERKAMP           Apple                50660 18-OCT-07          2            
CRUZEN               Apple                39109 02-OCT-07          1            
MESDAQ               Apple                98806 15-OCT-07          3            
SLINGLAND            Apple                47353 12-OCT-07          2            
SLINGLAND            Apple                87454 21-OCT-07          1            

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
ESPOSITA             Apple                48647 09-OCT-07          2            
ARNN                 Apple                11548 21-OCT-07          2            

13 rows selected.

SQL> 
SQL> REM 5. Create a view Cheap_View from Cheap_Food that shows only the product id, flavor
SQL> REM    and food.
SQL> 
SQL> create view cheap_view as (
  2  select pid , flavor, food
  3  from cheap_food );

View created.

SQL> 
SQL> select * from cheap_view;

PID             FLAVOR               FOOD                                       
--------------- -------------------- --------------------                       
70-LEM          Lemon                Cookie                                     
70-W            Walnut               Cookie                                     

SQL> select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where table_name = 'CHEAP_VIEW';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
PID                            YES                                              
FLAVOR                         YES                                              
FOOD                           YES                                              

SQL> 
SQL> insert into cheap_food values('Ac-RD-HG','gum','fondant',0.65);

1 row created.

SQL> 
SQL> update cheap_view
  2  set flavor = 'grapes'
  3  where flavor = 'gum';

1 row updated.

SQL> 

SQL> select * from cheap_food;

PID             FLAVOR               FOOD                      PRICE            
--------------- -------------------- -------------------- ----------            
70-LEM          Lemon                Cookie                      .79            
70-W            Walnut               Cookie                      .79            
Ac-RD-HG        grapes               fondant                     .65       
     
3 row created.
SQL> 
SQL> delete from cheap_food
  2  where pid= 'Ac-RD-HG';

1 row deleted.

SQL> select * from cheap_food;

PID             FLAVOR               FOOD                      PRICE            
--------------- -------------------- -------------------- ----------            
70-LEM          Lemon                Cookie                      .79            
70-W            Walnut               Cookie                      .79            
     
2 row created.
SQL> 
SQL> 
SQL> 
SQL> REM 6. Create a sequence named Ordinal_No_Seq which generates the ordinal number
SQL> REM    starting from 1, increment by 1, to a maximum of 10. Include the options of cycle,
SQL> REM    cache and order. Use this sequence to populate the item_list table for a new order.
SQL> 
SQL> insert into receipts values(00001, '31-Oct-2007', 17);

1 row created.

SQL> create sequence s
  2  start with 1
  3  increment by 1
  4  minvalue 1
  5  maxvalue 10
  6  nocycle
  7  order
  8  cache 10;

Sequence created.

SQL> 
SQL> insert into item_list values(00001, s.nextval,  '45-CO');

1 row created.

SQL> insert into item_list values(00001, s.nextval,  '90-APR-PF');

1 row created.

SQL> insert into item_list values(00001, s.nextval,  '50-CHS');

1 row created.

SQL> insert into item_list values(00001, s.nextval,  '50-APP');

1 row created.

SQL> insert into item_list values(00001, s.nextval,  '70-R');

1 row created.

SQL> 
SQL> select * from receipts
  2  where rno = 00001;

       RNO R_DATE           CID                                                 
---------- --------- ----------                                                 
         1 31-OCT-07         17                                                 

SQL> 
SQL> select * from item_list
  2  where rno = 00001
  3  order by rno;

       RNO    ORDINAL ITEM                                                      
---------- ---------- --------------------                                      
         1          1 45-CO                                                     
         1          2 90-APR-PF                                                 
         1          3 50-CHS                                                    
         1          4 50-APP                                                    
         1          5 70-R                                                      

SQL> 
SQL> REM 7. Create a synonym named Product_details for the item_list relation. Perform the
SQL> REM    DML operations on it.
SQL> 
SQL> create synonym product_details
  2  for item_list;

Synonym created.

SQL> 
SQL> select *
  2  from product_details
  3  where item =  '90-APR-PF';

       RNO    ORDINAL ITEM                                                      
---------- ---------- --------------------                                      
     83085          3 90-APR-PF                                                 
     27741          3 90-APR-PF                                                 
     95962          1 90-APR-PF                                                 
     44798          1 90-APR-PF                                                 
     21162          3 90-APR-PF                                                 
     82795          1 90-APR-PF                                                 
     37636          1 90-APR-PF                                                 
     86085          3 90-APR-PF                                                 
         1          2 90-APR-PF                                                 

9 rows selected.

SQL> 
SQL> insert into product_details values(insert into item_list values(91937, 8,	'51-BC');
                                   
1 row created.


SQL> 
SQL> update product_details
  2  set ordinal = ordinal+1
  3  where rno=91937 and ordinal = 8;
1 rows updated.

SQL> 
SQL> select * from item_list
  2  where rno = 91937;

       RNO    ORDINAL ITEM                                                      
---------- ---------- --------------------                                      
     91937          1 51-BC                                                     
     91937          2 51-APR                                                    
     91937          9 51-BC                                                    

SQL> 
SQL> delete from product_details
  2  where rno = 91937 and ordinal = 8;

1 rows deleted.

SQL> 
SQL> 
SQL> 
SQL> REM 8. Drop all the above created database objects.
SQL> 
SQL> drop view Blue_flavor;

View dropped.

SQL> drop view cheap_view;

View dropped.

SQL> drop view hot_food;

View dropped.

SQL> drop view pie_food;

View dropped.

SQL> drop view cheap_food;

View dropped.

SQL> drop sequence s;

Sequence dropped.

SQL> drop synonym product_details;

Synonym dropped.

SQL> delete from item_list where rno = 00001;

5 rows deleted.

SQL> delete from receipts where rno = 00001;

1 row deleted.

SQL> 
SQL> 
SQL> 
SQL> spool off
