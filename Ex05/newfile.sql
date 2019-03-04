REM 1. Check whether the given combination of food and flavor is available. If any one or
REM    both are not available, display the relevant message.
set serveroutput on;
create or replace procedure select_1(fl IN products.flavor%type, fo IN products.food%type, count_1 OUT integer) IS 
begin
	select count(*) into count_1
	from (select pid from products 
	where food=fo and flavor=fl);
end;
/
declare
fl products.flavor%type;
fo products.food%type;
c number(3);
begin	
	fl := &flavor;
	fo := &food;
	select_1(fl,fo,c);
	if SQL%found and c>0 then
		dbms_output.put_line(c||' found');
	else
		dbms_output.put_line('Not found');
	end if;
end;
/
REM 2. On a given date, find the number of items sold (Use Implicit cursor).
create or replace procedure select_2(date_1 IN receipts.rdate%type, count_1 OUT integer) IS 
begin
	select count(*) into count_1
	from (select rdate from item_list i join receipts r on r.rno=i.rno 
	where r.rdate=date_1);
end;
/
declare
date_search receipts.rdate%type;
c number(3);
begin	
	date_search := &date_search;
	select_2(date_search,c);
	if SQL%found and c>0 then
		dbms_output.put_line('No. of items sold on '||date_search||' is/are:'||c);
	else
		dbms_output.put_line('No items sold');
	end if;
end;
/