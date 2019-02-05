drop view itemno;
create view itemno as select item_list.rno, receipts.r_date, item_list.ordinal from item_list JOIN receipts on item_list.rno=receipts.rno;

create or replace procedure item_selector(d IN receipts.r_date%type) IS
begin	
	UPDATE itemno r 
	SET r.ordinal = r.ordinal+0	
	where r.r_date=d ;
	end;
declare 
datesearch receipts.r_date%type;
begin
	datesearch :=&datesearch;
	item_selector(datesearch);
	if SQL%found then
		dbms_output.put_line('Number of Items sold on '||datesearch||' are :'||SQL%ROWCOUNT);
	else 
		dbms_output.put_line('No Items sold');
	end if;
end;


	
		
	
	