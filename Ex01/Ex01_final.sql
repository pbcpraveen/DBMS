SQL> @Z:/Ex01.sql
SQL> 
SQL> REM ***SSN COLLEGE OF ENGINEERING***
SQL> REM ***DEPARTMENT OF COMPUTER SCIENCE ENGINEERING***
SQL> REM ***DATABASE MANAGEMENT SYSTEMS LAB***
SQL> REM ***Assignment 1: DdL Fundamentals***
SQL> 
SQL> REM ***Drop existing  tables***
SQL> Drop table order_details;

Table dropped.

SQL> drop table order_purchase;

Table dropped.

SQL> drop table part;

Table dropped.

SQL> drop table customer;

Table dropped.

SQL> drop table employee;

Table dropped.

SQL> drop table pincode;

Table dropped.

SQL> REM ***Creating Tables***
SQL> create table pincode(
  2  pin number(6) constraint pin_pk primary key,
  3  loc char(15)
  4  );

Table created.

SQL> REM ***** Voilating constraints of pincode table *****
SQL> REM Voilating pimary key constraint for pincode
SQL> insert into pincode(pin,loc)
  2  values(600103,'Anna nagar');

1 row created.

SQL> insert into pincode(pin,loc)
  2  values(600103,'KK nagar');
insert into pincode(pin,loc)
*
ERROR at line 1:
ORA-00001: unique constraint (4114.PIN_PK) violated 


SQL> create table employee(
  2  emp_no varchar2(5) constraint emp_pk primary key,
  3  emp_name char(15),
  4  dob DATE,
  5  pin number(6) constraint emp_fk references pincode(pin),
  6  constraint emp_format check(emp_no like 'E%')
  7  );

Table created.

SQL> REM ***** Voilating constraints of employee table *****
SQL> REM Voilating pimary key constraint for pincode
SQL> insert into employee(emp_no,emp_name,dob,pin)
  2  values('E0002','Jhon', TO_DATE('20/12/1995', 'DD/MM/YYYY'), 600103);

1 row created.

SQL> insert into employee(emp_no,emp_name,dob,pin)
  2  values('E0002','Mukesh', TO_DATE('20/12/1995', 'DD/MM/YYYY'), 600103);
insert into employee(emp_no,emp_name,dob,pin)
*
ERROR at line 1:
ORA-00001: unique constraint (4114.EMP_PK) violated 


SQL> REM voilating foreign key constraint of employee table
SQL> insert into employee(emp_no,emp_name,dob,pin)
  2  values('E0008','Susan', TO_DATE('15/06/1989', 'DD/MM/YYYY'), 600000);
insert into employee(emp_no,emp_name,dob,pin)
*
ERROR at line 1:
ORA-02291: integrity constraint (4114.EMP_FK) violated - parent key not found 


SQL> REM voilating check constraint for employee table
SQL> insert into employee(emp_no,emp_name,dob,pin)
  2  values('e0009','Susan', TO_DATE('15/06/1989', 'DD/MM/YYYY'), 600103);
insert into employee(emp_no,emp_name,dob,pin)
*
ERROR at line 1:
ORA-02290: check constraint (4114.EMP_FORMAT) violated 


SQL> create table customer(
  2  cust_no varchar2(10) constraint cus_pk primary key,
  3  cust_name char(15),
  4  street_name char(15),
  5  pin number(6) constraint cus_fk references pincode(pin),
  6  dob DATE,
  7  phone_no number(10) constraint ph_unique UNIQUE,
  8  constraint cus_format check(cust_no like 'C%')
  9  );

Table created.

SQL> REM ***** Voilating constraints of customer table *****
SQL> REM voilating primary key constraint of customer table
SQL> insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
  2  values('C00005', 'Jeff','Gold street', 600103, TO_DATE('26/01/1969','DD/MM/YYYY'), 8762390123);

1 row created.

SQL> insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
  2  values('C00005', 'Buff','Silver street', 600103, TO_DATE('26/01/1979','DD/MM/YYYY'), 8762390124);
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
*
ERROR at line 1:
ORA-00001: unique constraint (4114.CUS_PK) violated 


SQL> REM voilating foreign key constraint for customer table
SQL> insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
  2  values('C00006', 'Buff','Silver street', 600100, TO_DATE('26/01/1979','DD/MM/YYYY'), 8762390124);
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
*
ERROR at line 1:
ORA-02291: integrity constraint (4114.CUS_FK) violated - parent key not found 


SQL> REM voilating unique key contraint of phone number attribute
SQL> insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
  2  values('C00006', 'Buff','Silver street', 600103, TO_DATE('26/01/1979','DD/MM/YYYY'), 8762390123);
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
*
ERROR at line 1:
ORA-00001: unique constraint (4114.PH_UNIQUE) violated 


SQL> REM voilating check constraint of customer ID
SQL> insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
  2  values('c00006', 'Jeff','Gold street', 600103, TO_DATE('26/01/1969','DD/MM/YYYY'), 8762390123);
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
*
ERROR at line 1:
ORA-02290: check constraint (4114.CUS_FORMAT) violated 


SQL> create table part(
  2  p_no varchar2(15) constraint p_pk primary key,
  3  p_name char(15),
  4  price number(10) constraint p_par not null,
  5  qty number(10) constraint qty_ch check(qty>0),
  6  constraint part_format check (p_no like 'P%')
  7  );

Table created.

SQL> REM ***** Voilating constraints of part table *****
SQL> REM voilating primary key constraint of part table
SQL> insert into part(p_no, p_name, price, qty)
  2  values('P0011','Cotton', 300, 76);

1 row created.

SQL> insert into part(p_no, p_name, price, qty)
  2  values('P0011','Woll', 300, 76);
insert into part(p_no, p_name, price, qty)
*
ERROR at line 1:
ORA-00001: unique constraint (4114.P_PK) violated 


SQL> REM Voilating not null constraint of price
SQL> insert into part(p_no, p_name, price, qty)
  2  values('P0012','Fur', null, 76);
values('P0012','Fur', null, 76)
                      *
ERROR at line 2:
ORA-01400: cannot insert NULL into ("4114"."PART"."PRICE") 


SQL> REM voilating check constraint of quantity
SQL> insert into part(p_no, p_name, price, qty)
  2  values('P0013','Bed', 300, 0);
insert into part(p_no, p_name, price, qty)
*
ERROR at line 1:
ORA-02290: check constraint (4114.QTY_CH) violated 


SQL> REM voilating check constraint of part name
SQL> insert into part(p_no, p_name, price, qty)
  2  values('p0013','Bed', 300, 50);
insert into part(p_no, p_name, price, qty)
*
ERROR at line 1:
ORA-02290: check constraint (4114.PART_FORMAT) violated 


SQL> create table order_purchase(
  2  o_no varchar2(5) constraint or_k primary key,
  3  emp_no varchar2(5) constraint emp_fk1 references employee(emp_no),
  4  cust_no varchar2(10) constraint cust_fk1 references customer(cust_no),
  5  rd DATE,
  6  sd DATE,
  7  constraint date_ck check(rd<sd)
  8  );

Table created.

SQL> REM ***** Voilating constraints of order_purchase table *****
SQL> REM voilating primary key constraint of order_purchase table
SQL> insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
  2  values('1005','E0002','C00005',TO_DATE('03/08/2009', 'DD/MM/YYYY'),TO_DATE('09/10/2009', 'DD/MM/YYYY'));

1 row created.

SQL> insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
  2  values('1005','E0002','C00005',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/2009', 'DD/MM/YYYY'));
insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
*
ERROR at line 1:
ORA-00001: unique constraint (4114.OR_K) violated 


SQL> REM voilating foriegn key constraint of order_purchase table
SQL> insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
  2  values('1006','E1234','C00005',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/2009', 'DD/MM/YYYY'));
insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
*
ERROR at line 1:
ORA-02291: integrity constraint (4114.EMP_FK1) violated - parent key not found 


SQL> insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
  2  values('1007','E0002','C00032',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/2009', 'DD/MM/YYYY'));
insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
*
ERROR at line 1:
ORA-02291: integrity constraint (4114.CUST_FK1) violated - parent key not found 


SQL> REM voilating check constraint  rd<sd
SQL> insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
  2  values('1007','E0002','C00005',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/1999', 'DD/MM/YYYY'));
insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
*
ERROR at line 1:
ORA-02290: check constraint (4114.DATE_CK) violated 


SQL> create table order_details(
  2  o_no varchar2(5) constraint or_fk1 references order_purchase(o_no),
  3  p_no varchar2(15) constraint or_fk2 references part(p_no),
  4  qty number(10) constraint qtych2 check(qty>0),
  5  constraint  ord_pk primary key(o_no,p_no)
  6  );

Table created.

SQL> REM ***** Voilating constraints of order_details table *****
SQL> REM voilating primary key constraint of order_details table
SQL> insert into order_details(o_no, p_no,qty)
  2  values('1005','P0011',6);

1 row created.

SQL> insert into order_details(o_no, p_no,qty)
  2  values('1005','P0011',5);
insert into order_details(o_no, p_no,qty)
*
ERROR at line 1:
ORA-00001: unique constraint (4114.ORD_PK) violated 


SQL> REM voilating foreign key constraint of order_details table
SQL> insert into order_details(o_no, p_no,qty)
  2  values('1078','P0011',5);
insert into order_details(o_no, p_no,qty)
*
ERROR at line 1:
ORA-02291: integrity constraint (4114.OR_FK1) violated - parent key not found 


SQL> insert into order_details(o_no, p_no,qty)
  2  values('1005','P0099',5);
insert into order_details(o_no, p_no,qty)
*
ERROR at line 1:
ORA-02291: integrity constraint (4114.OR_FK2) violated - parent key not found 


SQL> 
SQL> REM *** THE DML COMMANDS ***
SQL> 
SQL> REM 7. It is identified that the following attributes are to be included in respective relations:Parts (reorder level), Employees (hiredate)
SQL> desc parts;
ERROR:
ORA-04043: object parts does not exist 


SQL> 
SQL> alter table part
  2  add reorder_level number(5);

Table altered.

SQL> 
SQL> desc part;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 P_NO                                      NOT NULL VARCHAR2(15)
 P_NAME                                             CHAR(15)
 PRICE                                     NOT NULL NUMBER(10)
 QTY                                                NUMBER(10)
 REORDER_LEVEL                                      NUMBER(5)

SQL> 
SQL> desc employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL VARCHAR2(5)
 EMP_NAME                                           CHAR(15)
 DOB                                                DATE
 PIN                                                NUMBER(6)

SQL> 
SQL> alter table employee
  2  add hiredate DATE;

Table altered.

SQL> 
SQL> desc employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL VARCHAR2(5)
 EMP_NAME                                           CHAR(15)
 DOB                                                DATE
 PIN                                                NUMBER(6)
 HIREDATE                                           DATE

SQL> 
SQL> REM 8.The width of a customer name is not adequate for most of the customers.
SQL> 
SQL> alter table customer
  2  modify cust_name char(30);

Table altered.

SQL> 
SQL> desc customer;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CUST_NO                                   NOT NULL VARCHAR2(10)
 CUST_NAME                                          CHAR(30)
 STREET_NAME                                        CHAR(15)
 PIN                                                NUMBER(6)
 DOB                                                DATE
 PHONE_NO                                           NUMBER(10)

SQL> 
SQL> REM 9. The dateofbirth of a customer can be addressed later / removed from the schema.
SQL> 
SQL> alter table customer
  2  drop column dob;

Table altered.

SQL> 
SQL> desc customer;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CUST_NO                                   NOT NULL VARCHAR2(10)
 CUST_NAME                                          CHAR(30)
 STREET_NAME                                        CHAR(15)
 PIN                                                NUMBER(6)
 PHONE_NO                                           NUMBER(10)

SQL> 
SQL> REM 10. An order can not be placed without the receive date.
SQL> 
SQL> alter table order_purchase
  2  modify rd date constraint ord_notnull not null;

Table altered.

SQL> 
SQL> desc order_purchase;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 O_NO                                      NOT NULL VARCHAR2(5)
 EMP_NO                                             VARCHAR2(5)
 CUST_NO                                            VARCHAR2(10)
 RD                                        NOT NULL DATE
 SD                                                 DATE

SQL> 
SQL> insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
  2  values('1006','E0002','C00004',null,TO_DATE('25/12/2010', 'DD/MM/YYYY'));
values('1006','E0002','C00004',null,TO_DATE('25/12/2010', 'DD/MM/YYYY'))
                               *
ERROR at line 2:
ORA-01400: cannot insert NULL into ("4114"."ORDER_PURCHASE"."RD") 


SQL> 
SQL> REM  11. A customer may cancel an order or ordered part(s) may not be available in a stock.
SQL> REM      Hence on removing the details of the order, ensure that all the corresponding details
SQL> REM      are also deleted.
SQL> 
SQL> insert into order_purchase(o_no,emp_no,cust_no,rd,sd)
  2  values('1007','E0002','C00005',TO_DATE('24/12/2018', 'DD/MM/YYYY'),TO_DATE('25/12/2018', 'DD/MM/YYYY'));

1 row created.

SQL> insert into order_details(o_no, p_no,qty)
  2  values('1007','P0011',6);

1 row created.

SQL> values('1008','E0002','C00005',TO_DATE('24/12/2018', 'DD/MM/YYYY'),TO_DATE('25/12/2018', 'DD/MM/YYYY'));
SP2-0734: unknown command beginning "values('10..." - rest of line ignored.
SQL> insert into order_details(o_no, p_no,qty)
  2  values('1008','P0011',6);
insert into order_details(o_no, p_no,qty)
*
ERROR at line 1:
ORA-02291: integrity constraint (4114.OR_FK1) violated - parent key not found 


SQL> 
SQL> delete from order_purchase
  2  where o_no = '1007';
delete from order_purchase
*
ERROR at line 1:
ORA-02292: integrity constraint (4114.OR_FK1) violated - child record found 


SQL> 
SQL> alter table order_details drop constraint or_fk1;

Table altered.

SQL> alter table order_details add constraint or_fk3 foreign key(o_no) references order_purchase(o_no) on delete cascade;

Table altered.

SQL> 
SQL> delete from order_purchase
  2  where o_no = '1008';

0 rows deleted.

SQL> 
SQL> 
SQL> desc order_details;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 O_NO                                      NOT NULL VARCHAR2(5)
 P_NO                                      NOT NULL VARCHAR2(15)
 QTY                                                NUMBER(10)

SQL> spool off
