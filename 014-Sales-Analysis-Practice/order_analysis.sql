-- Question 3: Show the order date and the quantity for each product ordered by each customer 
/* We want to see:
- Who bought something (the customer)
- What they bought (the product)
- How many they bought (quantity)
- When they bought it (the order date)
*/

select c.customer_id, concat(first_name, ' ', last_name) as customer_name,order_date, p.product_name, quantity
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
order by order_date
;

-- Question 6: Retrieve the orders made by customers who have spent more than the average customer spending
 -- 1. Calculate total spending per customer
 
select c.customer_id, concat(first_name, ' ', last_name) as customer_name, sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spent
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on oi.order_id = o.order_id
group by c.customer_id, customer_name
;
-- 2. average spending across all customers

select avg(total_spent)
from 
(select c.customer_id, concat(first_name, ' ', last_name) as customer_name, sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spent
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on oi.order_id = o.order_id
group by c.customer_id, customer_name
) as avg_total_spent
;


-- 3. Retrieve orders belonging to customers whose spending is above average
select o.order_id, o.order_date, o.customer_id
from orders as o
join order_items as oi
	 on o.order_id = oi.order_id
join ( select o.customer_id, sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spent
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on oi.order_id = o.order_id
group by o.customer_id
) as cs
	on o.customer_id = cs.customer_id
where cs.total_spent > 
(select avg(total_spent)
from 
(select c.customer_id, concat(first_name, ' ', last_name) as customer_name, sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spent
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on oi.order_id = o.order_id
group by c.customer_id, customer_name
) as avg_cs
)
;