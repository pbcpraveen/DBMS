REM : 1. Display the food details that is not purchased by any of customers.


SELECT 	* 
FROM products 
where pid not in ( SELECT distinct item from item_list);


REM : 2. Show the customer details who had placed more than 2 orders on the same date.

SELECT * 
FROM customers
WHERE cid in (SELECT cid from receipts 
              GROUP BY cid,r_date
			  HAVING count(*)>2);
			  
REM : 3. Display the products details that has been ordered maximum by the customers. (use ALL)

SELECT * 
FROM products
WHERE pid  in( select item 
				from item_list
				group by item
				having count(*)>= all (select count(*)
									   from item_list
									   group by(item)
									   )
			);

REM : 4. Show the number of receipts that contain the product whose price is more than the 
REM      average price of its food type.

SELECT count(distinct item) as number_of_receipts
from item_list
where item in (select pid 
             from products parent 
			 where price >= (select avg(price)
								from products child 
								where child.food = parent.food 
								)); 
								
								
REM : 5. Display the customer details along with receipt number and date for the receipts that 
REM      are dated on the last day of the receipt month.

SELECT *
FROM customers join receipts on customers.cid = receipts.cid
where rno in (select rno 
			from receipts parent
			where r_date in (select max(r_date)
			                    from receipts child
								where extract(month from parent.r_date)=extract(month from child.r_date)
								and extract(year from parent.r_date)=extract(year from child.r_date)));
								
REM 6. Display the receipt number(s) and its total price for the receipt(s) that contain Twist 
REM    as one among five items. Include only the receipts with total price more than $25.

SELECT i2.rno, sum(p1.price)
from products p1 join item_list i2 on p1.pid = i2.item
where (select pid from products where flavor = 'Twist') in (select i1.item
                                                          from item_list i1
                                                           where i1.rno = i2.rno
)
group by i2.rno
having sum(p1.price)>25;



REM 7. Display the receipt no having the same productid in the same ordinal position

select l1.rno
from  item_list l1
where l1.ordinal in (select l2.ordinal 
                   from item_list l2
				    where l1.rno = l2.rno)
and l1.item in (select l3.item
                from item_list l3
                 where l1.rno != l3.rno and l1.ordinal = l3.ordinal)
group by l1.rno;
REM doubt

REM 8. Display the list of customers who purchased baked food of Chocolate and
REM    Apricot flavor for more than once.

select c1.cid 
from customers c1 join receipts r1 on c1.cid = r1.cid
where r1.rno = any(select i1.rno from item_list i1 join products p1 on p1.pid = i1.item
                   where  p1.food = 'Chocolate')
and r1.rno = any (select i1.rno from item_list i1 join products p1 on p1.pid = i1.item
                   where  p1.food = 'Apricot')
group by c1.cid 
having count(*)>1;