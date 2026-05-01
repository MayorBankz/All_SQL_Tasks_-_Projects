/* VIEW TASKS 
QUESTION 1: Find the running total of sales for each month */

CREATE VIEW salesdb.Running_total_per_month as (
select 
year(orderdate) as year,
month(orderdate) as month,
sales,
sum(sales) over(partition by year(orderdate), month(orderdate) order by orderdate) as running_total
from orders);

/* Question 2: Provide a view that combines details from orders, products, customers, and employees */

create view sales_details as select c.customerid,
e.employeeid,
o.orderid,
p.product,
p.price,
o.quantity,
o.sales
from products as p
left join orders as o
	on p.productid = o.productid
left join customers as c
	on c.customerid = o.customerid
left join employees as e
	on e.employeeid = o.salespersonid;

-- To delete a view
Drop view running_total_per_month;

/* How to update a logic of a view in SQL 
Let's say you already have the view customers_total
*/

create view customers_total as 
select customerid,
sum(sales) as total_sales
from orders
group by customerid
;

/* Now you want to update it (add order count) 

create or replace view customers_total as 
select customerid,
sum(sales) as total_sales,
count(orderid) as total_orders
from orders
group by customerid

Not supported in this version of SQL*/
