-- SUBQUERY TASKS 
/* QUESTION 1: Find the products that have a price higher than the average price of all products 
Explanation
- The subquery runs first - This calculates the average price of all products in the table
- The outer query retrieves productid, product, and price from the products table
- The WHERE clause compares each product's price to the average price returned by the subquery
- Only products with a price greater than the average price are returned*/

select *
from salesdb.products;

select productid, 
product,
price
from salesdb.products
where price > (select avg(price)
from salesdb.products);

/* QUESTION 2: Rank customers based on their total amount of sales 
Explanation
- This is a subquery in the FROM clause.
- The subquery calculates the total sales for each customer using SUM(sales) and GROUP BY customerid
- The result of the subquery acts a temporary table (derived table) containing customerid and their total sales
- The outer query reads from this derived table
- The RANK() window function ranks customers based on their total sales in descending order, giving the highest sales rank 1*/


select customerid,
customer_total,
rank() over(order by customer_total desc) as sales_rank
from (select customerid,
sum(sales) as customer_total
from salesdb.orders
group by customerid) t;

/* QUESTION 3: show the product IDs, productnames, prices, and total number of orders. 
Explanation 
- This query uses a subquery in the FROM clause (It is specifically called a derived table)
- The subquery counts the total number of orders for each product using COUNT() and GROUP BY productid
- The result of the subquery creates a temporary table containing productid and total_orders
- The outer query joins the products table with the subquery result using productid
- This allows us to display the productid, productname, price, and the total number of orders */

select p.productid,
p.product,
p.price,
t.total_orders
from salesdb.products as p
join (select productid,
count(orderid) as total_orders
from salesdb.orders
group by productid) t
	on p.productid = t.productid;
    
/* QUESTION 4: Show all customer details and find the total orders of each customer
- The subquery counts the total number of orders for each customer using COUNT(orderid) and GROUP BY customerid
- The subquery result acts as a temporary table (derived table) containing customerid and total_orders.
- The outer query joins the customers table with the derived table on customerid.
- The result displays all customer details along with the total number of orders for each customer. */

select *
from salesdb.customers as s 
left join (select customerid,
count(orderid) as total_orders
from salesdb.orders
group by customerid) t
on s.customerid = t.customerid
;

/* QUESTION 5: Find the products that have a price higher than the average price of all products. 
Explanation
- The subquery calculates the average price of all products using AVG(price).
- The outer query selects productid, product name, and price from the products table.
- The WHERE clause compares each product's price to the average price returned by the subquery.
- Only products with a price higher than the average are returned.*/

select productid,
product,
price
from salesdb.products
where price > (select avg(price) 
from salesdb.products);

/* QUESTION 6: Show the details of orders made by customers in Germany 
Explanation
- The subquery selects all customerids from the customers table where country is 'Germany' 
- The outer query selects all columns from the orders table
- The WHERE clause filters orders to include only those who customerid matches the IDs returned by the subquery 
- The result shows all orders made by customers located in Germany*/

select *
from salesdb.orders
where customerid in (select customerid
from salesdb.customers
where country = 'Germany');

/* QUESTION 7: Show the details of orders for customers who are not from Germany. 
Explanation
- The subquery retrieves customerids of customers whose country is Germany.
- The outer query selects all order details from the orders table
- The NOT IN operator excludes orders whose customerid appears in subquery result
- The result shows orders made by customers who are not from Germany*/

select *
from salesdb.orders
where customerid not in (select customerid
from salesdb.customers
where country = 'Germany');

/* QUESTION 8: Find female employees whose salaries are greater than salaries on any male employees. 
Explanation 
- The subquery selects the salaries of all male employees from the employee table.
- The outer query selects details of employees whose Gender is 'Female'
- The ANY operator compares each female employee's salary with the salaries returned by the subquery
- It returns the female employees whose salary is greater than at least one male employee's salary*/

select *
from salesdb.employees
where gender= 'F' and salary > any (select salary
from salesdb.employees
where gender = 'M');

/* QUESTION 9: show all customers details and find the total orders for each customer. 
Explanation
- The subquery counts the total number of orders for each customer using COUNT(orderid) and GROUP BY customerid.
- The subquery result creates a temporary table containing customerid and total_orders. 
- The outer query selects all customer details from the customers table.
- The customers table is joined with the subquery using customerid to display each customer's total orders*/

select *
from salesdb.customers as c
left join (select customerid,
count(orderid) as total_orders
from salesdb.orders as o
group by customerid) t
	on c.customerid = t.customerid
    ;
    
/* QUESTION 10: Show the order details for customers in Germany */

select *
from salesdb.orders as o 
join (select customerid,
country
from salesdb.customers as c
where country = 'Germany') t
	on o.customerid = t.customerid;
    
    /* QUESTION 10(Method 2) */
select *
from salesdb.orders o
where exists (
    select 1
    from salesdb.customers c
    where c.customerid = o.customerid
    and c.country = 'Germany'
);
    
