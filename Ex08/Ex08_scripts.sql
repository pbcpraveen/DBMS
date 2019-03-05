SQL> @D:/Ex08.sql
SQL> REM 1. For the given receipt number, if there are no rows then display as
SQL> REM “No order with the given receipt <number>”. If the receipt contains more
SQL> REM than one item, display as “The given receipt <number> contains more than
SQL> REM one item”. If the receipt contains single item, display as “The given
SQL> REM receipt <number> contains exactly one item”. Use predefined exception handling.
SQL> 
SQL> declare
  2  i products.pid%type;
  3  r receipts.rno%type;
  4  begin
  5  r := &receipt_no;
  6  begin
  7  select i1.item into i from item_list i1 where i1.rno = r;
  8  EXCEPTION WHEN NO_DATA_FOUND then
  9  dbms_output.put_line('NO SUCH DATA');
 10  RETURN;
 11  WHEN TOO_MANY_ROWS THEN
 12  DBMS_OUTPUT.PUT_LINE('More than one receipts were found for '||r);
 13  RETURN;
 14  end;
 15  if SQL%ROWCOUNT=1 then
 16  DBMS_OUTPUT.PUT_LINE('One receipt was found for '||r);
 17  end if;
 18  end;
 19  /
Enter value for receipt_no: 67314
old   5: r := &receipt_no;
new   5: r := 67314;
More than one receipts were found for 67314                                     

PL/SQL procedure successfully completed.

SQL> REM 2. While inserting the receipt details, raise an exception when the
SQL> REM receipt date is greater than the current date.
SQL> 
SQL> declare
  2  INVALID_DATE EXCEPTION;
  3  rec Receipts.rno%type;
  4  rd date;
  5  custid Receipts.cid%type;
  6  cd date;
  7  begin
  8  select sysdate into cd from dual;
  9  rec := &Receipt_no;
 10  custid:= &CID;
 11  rd := &Receipt_date;
 12  begin
 13  if rd > cd then
 14  raise INVALID_DATE;
 15  end if;
 16  exception when INVALID_DATE then
 17  dbms_output.put_line('Date is greater than current date: Receipt cannot be inserted');
 18  return;
 19  end;
 20  insert into Receipts values(rec, rd, custid);
 21  end;
 22
 23  /
Enter value for receipt_no: 50000
old   9: rec := &Receipt_no;
new   9: rec := 50000;
Enter value for cid: 5
old  10: custid:= &CID;
new  10: custid:= 5;
Enter value for receipt_date: '2-oct-2019'
old  11: rd := &Receipt_date;
new  11: rd := '2-oct-2019';
Date is greater than current date: Receipt cannot be inserted

PL/SQL procedure successfully completed.

SQL>

SQL> spool off;
