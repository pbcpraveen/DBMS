
REM ***SSN COLLEGE OF ENGINEERING***
REM ***DEPARTMENT OF COMPUTER SCIENCE ENGINEERING***
REM ***DATABASE MANAGEMENT SYSTEMS LAB***
REM ***Assignment 3***

REM Creating Tables
drop table item_list;
drop table receipts;
drop table products;
drop table customers;



create table customers(
cid number(10) constraint c_pk primary key,
lname char(20) ,
fname char(20)
);


create table products(
pid varchar2(15) constraint pid_pk primary key,
food char(20) ,
flavor char(20),
price decimal(5,2)
);

create table receipts (
rno number(10) constraint i_pk primary key,
r_date DATE ,
cid number(10) constraints c_fk references customers(cid)
);

create table item_list(
rno number(10) constraint r_fk references receipts(rno),
ordinal number(10),
item varchar2(20) constraint r_fk2 references products(pid),
constraint ic_pk primary key(rno,ordinal)
);



