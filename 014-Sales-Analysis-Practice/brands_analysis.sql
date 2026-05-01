-- Question 1: Find the brands that have sold more than 100 products in total 

/* We want to know
- which brands 
- Have sold more than 100 items
- When we add up all their sales together

Break it down simply 
- Brands - Product makers (for example: Nike, Samsung, Apple)
- Sold - Customers bought their products
- More than 100 products - total items sold is greater than 100
- In total - all sales added together, not per order or per day
*/

select brand_name, sum(oi.quantity) as total_products_sold
from brands as b
join products as p
	on b.brand_id = p.brand_id
join order_items as oi
	on p.product_id = oi.product_id
group by brand_name
having total_products_sold > 100
order by total_sold
;
