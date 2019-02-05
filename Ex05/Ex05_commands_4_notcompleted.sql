declare 
cust_name1 customers.lname%type;
cust_name2 customers.fname%type;
qty number(3);
counts number(3);
food_sel products.food%type;
flavor_sel products.flavor%type;
rec_sel receipts.rno%type;
cursor c1 is select food, flavor, count(*) as qty from products p join item_list i on i.item = p.pid where i.rno = rec_sel group by pid;
begin
rec_sel := &rec_sel;
cursor c1 is select food, flavor, count(*) as qty from products p join item_list i on i.item = p.pid where i.rno = rec_sel group by pid;

select count(count(*)) into counts from products p join item_list i on i.item = p.pid 
where i.rno = rec_sel
group by pid;

select fname,lname into cust_name1,cust_name2 from customers c join receipts r on r.cid = c.cid
where r.rno = rec_sel;

dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2); 
dbms_output.put_line('FOOD   FLAVOR   QUANTITY');
 for count in 1..counts loop
            fetch c1 into food_sel,flavor_sel,qty;
            dbms_output.put_line(food_sel||' '||flavor_sel||' '||qty||);
    end loop;
end;
