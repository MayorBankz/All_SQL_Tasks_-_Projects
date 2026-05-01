-- Question 7: List the products with the highest order quantity in the last 6 months of 2017 

-- Step 1: list all the order quantity for the products in the last 6 months of 2017
select p.product_id, p.product_name, o.order_date, sum(oi.quantity) as total_quantity
from products as p
join order_items as oi
	on p.product_id = oi.product_id
join orders as o
	on o.order_id = oi.order_id
where o.order_date between '2017-07-01' and '2017-12-31'
group by p.product_id, p.product_name, o.order_date
;

-- For products with the highest order quantity

select max(total_quantity)
from (select sum(oi.quantity) as total_quantity 
from products as p
join order_items as oi
	on p.product_id = oi.product_id
join orders as o
	on o.order_id = oi.order_id
where o.order_date between '2017-07-01' and '2017-12-31'
group by p.product_id
) as max_total_quantity
;

-- Therefore to list the products with the highest order quantity in the last months of 2017
select p.product_id, p.product_name, sum(oi.quantity) as total_quantity
from products as p
join order_items as oi
	on p.product_id = oi.product_id
join orders as o
	on o.order_id = oi.order_id
where o.order_date between '2017-07-01' and '2017-12-31'
group by p.product_id, p.product_name
having sum(oi.quantity) =
(
select max(total_quantity)
from (select sum(oi.quantity) as total_quantity 
from products as p
join order_items as oi
	on p.product_id = oi.product_id
join orders as o
	on o.order_id = oi.order_id
where o.order_date between '2017-07-01' and '2017-12-31'
group by p.product_id
) as h_qty
)
;
;
