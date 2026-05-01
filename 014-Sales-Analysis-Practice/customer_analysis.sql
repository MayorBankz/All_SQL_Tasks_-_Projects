
-- Question 2: List all customers who have ordered a product that costs over $500

/* What the question wants 
- A list of customers
- Who have ordered at least one product
- Whose unit price is greater than $500
	It does not ask for product prices in thr output
*/

select distinct concat(first_name, ' ', last_name) as customer_name
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where p.list_price > 500
order by customer_name
;



-- Question 4: Get the name of customers who ordered products with a price greater than $1000

/* The key thing here:
- We only need customer names
- We don't have to show product details or price
- Each customer should ideally appear once
*/

select concat(first_name, ' ', last_name) as customer_name
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on p.product_id = oi.product_id
where p.list_price > 1000
order by customer_name
;



-- Question 5: Find customers who have placed more than 2 orders

select c.customer_id, concat(first_name, ' ', last_name) as customer_name, count(o.order_id) as total_order
from orders as o
join customers as c
	on o.customer_id = c.customer_id
group by customer_id, customer_name
having total_order > 2
order by customer_name
;





-- Question 8: Find the customer who has spent the most on a single order

/* what this really means
- Calculate the total value of each order
- Compare order totals
- find the one order with the highest total
- Return the customer who placed that order
*/

select c.customer_id, concat(first_name, ' ', last_name) as customer_name, oi.order_id, sum((oi.quantity * oi.list_price) * (1 - oi.discount)) as total_order
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join customers as c
	on c.customer_id = o.customer_id
group by customer_id, customer_name, oi.order_id
order by total_order desc
limit 1;



-- Question 10: List the customers who have place orders in 2016 but not in 2018
/* find customer who:
- bought something in 2016
- Did not buy anything in 2018 
*/

select c.customer_id, concat(first_name, ' ', last_name) as customer_name, order_date
from customers as c
join orders as o
	on c.customer_id = o.customer_id
where order_date between '2016-01-01' and '2016-12-31'
and not exists (
select customer_id 
from orders as o2
where o2.customer_id = o.customer_id
and o2.order_date between '2018-01-01' and '2018-12-31'
)
;
