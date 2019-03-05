REM 1. For the given receipt number, if there are no rows then display as 
REM “No order with the given receipt <number>”. If the receipt contains more 
REM than one item, display as “The given receipt <number> contains more than 
REM one item”. If the receipt contains single item, display as “The given 
REM receipt <number> contains exactly one item”. Use predefined exception handling.

declare
i products.pid%type;
r receipts.rno%type;
begin
r := &receipt_no;
begin
select i1.item into i from item_list i1 where i1.rno = r;
EXCEPTION WHEN NO_DATA_FOUND then
dbms_output.put_line('NO SUCH DATA');
RETURN;
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE('More than one receipts were found for '||r);
RETURN;
end;
if SQL%ROWCOUNT=1 then
DBMS_OUTPUT.PUT_LINE('One receipt was found for '||r);
end if;
end;

REM 2. While inserting the receipt details, raise an exception when the 
REM receipt date is greater than the current date.

declare
INVALID_DATE EXCEPTION;
rec Receipts.rno%type;
rd date;
custid Receipts.cid%type;
cd date;
begin
select sysdate into cd from dual;
rec := &Receipt_no;
custid:= &CID;
rd := &Receipt_date;
begin
if rd > cd then
raise INVALID_DATE;
end if;
exception when INVALID_DATE then
dbms_output.put_line('Date is greater than current date: Receipt cannot be inserted');
return;
end;
insert into Receipts values(rec, rd, custid);
end;

