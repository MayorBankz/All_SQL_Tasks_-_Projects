-- Question 9: Retrieve revenue generated from each state.

select state, sum((oi.quantity * oi.list_price) * ( 1 - discount)) as total_revenue
from customers as c
join orders as o
	on c.customer_id = o.customer_id
join order_items as oi
	on o.order_id = oi.order_id
group by state
;