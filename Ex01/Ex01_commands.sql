
REM ***SSN COLLEGE OF ENGINEERING***
REM ***DEPARTMENT OF COMPUTER SCIENCE ENGINEERING***
REM ***DATABASE MANAGEMENT SYSTEMS LAB***
REM ***Assignment 1: DDL Fundamentals***

REM ***Drop existing  tables***
Drop table order_details;
drop table order_purchase;
drop table part;
drop table customer;
drop table employee;
drop table pincode; 
REM ***Creating Tables***
create table pincode(
pin number(6) constraint pin_pk primary key,
loc char(15)
);
REM ***** Voilating constraints of pincode table *****
REM Voilating pimary key constraint for pincode 
insert into pincode(pin,loc)
values(600103,'Anna nagar');
insert into pincode(pin,loc)
values(600103,'KK nagar');
create table employee(
emp_no varchar2(5) constraint emp_pk primary key,
emp_name char(15),
dob DATE,
pin number(6) constraint emp_fk references pincode(pin),
constraint emp_format check(emp_no like 'E%')
); 
REM ***** Voilating constraints of employee table *****
REM Voilating pimary key constraint for pincode
insert into employee(emp_no,emp_name,dob,pin)
values('E0002','Jhon', TO_DATE('20/12/1995', 'DD/MM/YYYY'), 600103);
insert into employee(emp_no,emp_name,dob,pin)
values('E0002','Mukesh', TO_DATE('20/12/1995', 'DD/MM/YYYY'), 600103);
REM voilating foreign key constraint of employee table
insert into employee(emp_no,emp_name,dob,pin)
values('E0008','Susan', TO_DATE('15/06/1989', 'DD/MM/YYYY'), 600000);
REM voilating check constraint for employee table 
insert into employee(emp_no,emp_name,dob,pin)
values('e0009','Susan', TO_DATE('15/06/1989', 'DD/MM/YYYY'), 600103);
create table customer(
cust_no varchar2(10) constraint cus_pk primary key,
cust_name char(15),
street_name char(15),
pin number(6) constraint cus_fk references pincode(pin),
dob DATE,
phone_no number(10) constraint ph_unique UNIQUE,
constraint cus_format check(cust_no like 'C%')
);
REM ***** Voilating constraints of customer table *****
REM voilating primary key constraint of customer table
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
values('C00005', 'Jeff','Gold street', 600103, TO_DATE('26/01/1969','DD/MM/YYYY'), 8762390123);
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
values('C00005', 'Buff','Silver street', 600103, TO_DATE('26/01/1979','DD/MM/YYYY'), 8762390124);
REM voilating foreign key constraint for customer table
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
values('C00006', 'Buff','Silver street', 600100, TO_DATE('26/01/1979','DD/MM/YYYY'), 8762390124);
REM voilating unique key contraint of phone number attribute
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
values('C00006', 'Buff','Silver street', 600103, TO_DATE('26/01/1979','DD/MM/YYYY'), 8762390123);
REM voilating check constraint of customer ID
insert into customer(cust_no, cust_name, street_name,pin, dob, phone_no)
values('c00006', 'Jeff','Gold street', 600103, TO_DATE('26/01/1969','DD/MM/YYYY'), 8762390123);
create table part(
p_no varchar2(15) constraint p_pk primary key,
p_name char(15),
price number(10) constraint p_par not null,
qty number(10) constraint qty_ch check(qty>0),
constraint part_format check (p_no like 'P%')
);
REM ***** Voilating constraints of part table *****
REM voilating primary key constraint of part table
insert into part(p_no, p_name, price, qty)
values('P0011','Cotton', 300, 76);
insert into part(p_no, p_name, price, qty)
values('P0011','Woll', 300, 76);
REM Voilating not null constraint of price
insert into part(p_no, p_name, price, qty)
values('P0012','Fur', null, 76);
REM voilating check constraint of quantity
insert into part(p_no, p_name, price, qty)
values('P0013','Bed', 300, 0);
REM voilating check constraint of part name
insert into part(p_no, p_name, price, qty)
values('p0013','Bed', 300, 50);
create table order_purchase(
o_no varchar2(5) constraint or_k primary key,
emp_no varchar2(5) constraint emp_fk1 references employee(emp_no),
cust_no varchar2(10) constraint cust_fk1 references customer(cust_no),
rd DATE,
sd DATE,
constraint date_ck check(rd<sd)
);
REM ***** Voilating constraints of order_purchase table *****
REM voilating primary key constraint of order_purchase table
insert into order_purchase(o_no,emp_no,cust_no,rd,sd) 
values('1005','E0002','C00005',TO_DATE('03/08/2009', 'DD/MM/YYYY'),TO_DATE('09/10/2009', 'DD/MM/YYYY'));
insert into order_purchase(o_no,emp_no,cust_no,rd,sd) 
values('1005','E0002','C00005',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/2009', 'DD/MM/YYYY'));
REM voilating foriegn key constraint of order_purchase table
insert into order_purchase(o_no,emp_no,cust_no,rd,sd) 
values('1006','E1234','C00005',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/2009', 'DD/MM/YYYY'));
insert into order_purchase(o_no,emp_no,cust_no,rd,sd) 
values('1007','E0002','C00032',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/2009', 'DD/MM/YYYY'));
REM voilating check constraint  rd<sd
insert into order_purchase(o_no,emp_no,cust_no,rd,sd) 
values('1007','E0002','C00005',TO_DATE('04/08/2009', 'DD/MM/YYYY'),TO_DATE('10/10/1999', 'DD/MM/YYYY'));
create table order_details(
o_no varchar2(5) constraint or_fk1 references order_purchase(o_no),
p_no varchar2(15) constraint or_fk2 references part(p_no),
qty number(10) constraint qtych2 check(qty>0),
constraint  ord_pk primary key(o_no,p_no)
);
REM ***** Voilating constraints of order_details table *****
REM voilating primary key constraint of order_details table
insert into order_details(o_no, p_no,qty) 
values('1005','P0011',6);
insert into order_details(o_no, p_no,qty) 
values('1005','P0011',5);
REM voilating foreign key constraint of order_details table
insert into order_details(o_no, p_no,qty) 
values('1078','P0011',5);
insert into order_details(o_no, p_no,qty) 
values('1005','P0099',5);

REM *** THE DML COMMANDS ***

REM 7. It is identified that the following attributes are to be included in respective relations:Parts (reorder level), Employees (hiredate)
desc parts;

alter table part
add reorder_level number(5);

desc part;

desc employee;

alter table employee
add hiredate DATE;

desc employee;

REM 8.The width of a customer name is not adequate for most of the customers.

alter table customer
modify cust_name char(30);

desc customer;

REM 9. The dateofbirth of a customer can be addressed later / removed from the schema.

alter table customer
drop column dob;

desc customer;

REM 10. An order can not be placed without the receive date.

alter table order_purchase
modify rd date constraint ord_notnull not null;

desc order_purchase;

insert into order_purchase(o_no,emp_no,cust_no,rd,sd) 
values('1006','E0002','C00004',null,TO_DATE('25/12/2010', 'DD/MM/YYYY'));

REM  11. A customer may cancel an order or ordered part(s) may not be available in a stock.
REM      Hence on removing the details of the order, ensure that all the corresponding details
REM      are also deleted.

insert into order_purchase(o_no,emp_no,cust_no,rd,sd) 
values('1007','E0002','C00005',TO_DATE('24/12/2018', 'DD/MM/YYYY'),TO_DATE('25/12/2018', 'DD/MM/YYYY'));
insert into order_details(o_no, p_no,qty) 
values('1007','P0011',6);
values('1008','E0002','C00005',TO_DATE('24/12/2018', 'DD/MM/YYYY'),TO_DATE('25/12/2018', 'DD/MM/YYYY'));
insert into order_details(o_no, p_no,qty) 
values('1008','P0011',6);

delete from order_purchase
where o_no = '1007';

alter table order_details drop constraint or_fk1;
alter table order_details add constraint or_fk3 foreign key(o_no) references order_purchase(o_no) on delete cascade;

delete from order_purchase
where o_no = '1008';


desc order_details;