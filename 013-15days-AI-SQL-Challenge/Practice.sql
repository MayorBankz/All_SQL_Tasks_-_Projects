/* 15 days challenge practice SQL tutor by AI */

/* 🔥 Challenge 1

From the orders table:

Return the top 3 highest sales orders

Include: orderid, orderdate, sales

If two orders have the same sales, they should share the same rank

No subquery if possible */

select * 
from (select orderid,
orderdate, 
sales,
rank() over(order by sales desc) as sales_rank
from orders) t
where sales_rank <= 3;

/* Challenge 2: 🎯 Scenario:

From the orders table:

Return:

orderid

customerid

sales

The average sales per customer

A column showing whether the order is:

'Above Average'

'Below Average'

'Equal Average' */

Select 
orderid, 
customerid, 
sales,
avg(sales) over(partition by customerid) as avg_sales_per_customer,
case 
	when sales > avg(sales) over(partition by customerid) then 'Above Average'
    when sales < avg(sales) over(partition by customerid) then 'Below Average'
	Else 'Equal Average'
End AS sales_comparison
from orders;

/* Challenge 3: Second Highest Per Customer
From the orders table:

Return:

customerid

orderid

sales

But only return the second highest sales order for each customer.

⚠️ Rules

Must use a window function

No LIMIT

Should work even if customers have many orders

If a customer has only one order → they should NOT appear
*/

select *
from (select customerid,
orderid, 
sales,
dense_rank() over(partition by customerid order by sales desc) as sales_rank
from orders) t
where sales_rank = 2;

/* 1️⃣ Fast Timed Drill (Speed Test)

⏱ Try to solve this in under 5 minutes.

From orders:

Return:

orderid

customerid

sales

Rank orders per customer from lowest to highest sales

But:

If two sales are equal, they must share the same rank

No subquery

Think:
Ascending order.
Ties allowed.
No filtering required.

Drop it fast. */

select orderid,
customerid,
sales,
rank() over(partition by customerid order by sales asc) as sales_rank
from orders;

/* From orders:

Find customers whose total sales are above the average total sales of all customers.

Return:

customerid

total_sales

Rules:

Must use a window function

Avoid nested aggregation mistakes

Clean logic

This tests whether you truly understand aggregation layering.*/

select *
from (select customerid, 
total_sales,
avg(total_sales) over() as avg_total_sales
from 
(select customerid,
sum(sales) as total_sales
from orders
group by customerid) t
) x
where total_sales > avg_total_sales;

/* From orders, return for each order:

orderid

customerid

sales

prev_order_sales → the previous order’s sales for that customer (ordered by orderdate)

sales_diff → difference between current order sales and previous order sales

Rules:

Must use a window function

No self-joins

Should handle NULL when there’s no previous order

🔑 Hints

Use LAG() — it’s the opposite of LEAD()

LAG(column) OVER(PARTITION BY customerid ORDER BY orderdate)

Subtract to get sales_diff */

select orderid,
customerid,
sales,
lag(sales) over(partition by customerid order by orderdate) as prev_order_sales,
sales - lag(sales) over(partition by customerid order by orderdate) as sales_diff
from orders;

/* 🔥 Challenge 1 – Top 2 Orders & Previous Order Difference

From orders:

Return customerid, orderid, sales

Include prev_order_sales using LAG()

Include rank_per_customer — rank orders per customer from highest to lowest sales

Only return the top 2 orders per customer

Hints:

DENSE_RANK() or RANK() for ranking

Filter after computing the rank */

select *
from (select customerid,
orderid,
sales,
lag(sales) over(partition by customerid order by orderdate) as prev_order_sales,
dense_rank() over(partition by customerid order by sales desc) as sales_rank
from orders ) t
where sales_rank <= 2;

/* Challenge 2 – Above Average Order Comparison

From orders:

Return orderid, customerid, sales

Compute avg_sales_customer (average sales per customer)

Show a column above_avg_flag → 'Yes' if sales > avg_sales_customer, else 'No'

Also include prev_order_sales

No subquery in SELECT; use window functions only

Hints:

Combine AVG() OVER(PARTITION BY ...) and LAG()

You’ll need to repeat window functions if you reference them in the same SELECT */

select orderid, 
customerid, 
sales,
lag(sales) over(partition by customerid order by orderdate) as prev_order_sales,
avg(sales) over(partition by customerid) as avg_sales_customer,
case
	when sales > avg(sales) over(partition by customerid) then 'YES'
    else 'NO'
end as above_avg_flag
from orders;

/* Challenge 3 – Sales Momentum

From orders, return for each order:

customerid

orderid

sales

sales_diff → difference between current and previous order (LAG)

rank_by_sales → rank orders per customer, highest to lowest

cumulative_sales → running total of sales per customer (SUM)

Rules:

Must use window functions only

No self-joins

Proper ordering per customer

Handle NULLs correctly for first order

Step-by-Step Plan

Previous order sales → LAG(sales) OVER (PARTITION BY customerid ORDER BY orderdate)

Sales difference → sales - LAG(sales) OVER (...)

Rank orders per customer → RANK() OVER (PARTITION BY customerid ORDER BY sales DESC)

Cumulative sales → SUM(sales) OVER (PARTITION BY customerid ORDER BY orderdate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

Take your time and drop your query. We’ll review it line by line so no alias/window function mistakes sneak through.

Ready? */

select customerid,
orderid,
sales,
rank() over(partition by customerid order by sales desc) as rank_by_sales,
lag(sales) over(partition by customerid order by orderdate) as prev_order,
sum(sales) over(partition by customerid order by orderdate rows between unbounded preceding and current row) as cummulative_sales,
sales - lag(sales) over(partition by customerid order by orderdate) as sales_diff
from orders;

/* Day 3: Assume we have this table:

- orders

- order_id

- customer_id

- order_date

- sales

Question 1 – Customer Performance Tiering

For each customer:

1. Calculate their total_sales

2. Rank customers based on total_sales (highest first)

3. Assign a performance label:

4. Top 3 → "High Value"

5. Rank 4–6 → "Mid Value"

Others → "Low Value" */

select customer_id,
total_sales,
sales_rank,
case 
	when total_sales <= 3 then 'High Value'
    when total_sales between 4 and 6 then 'Mid Value'
else 'Low Value'
End as Performance_label
from (select 
customer_id,
sum(sales) as total_sales,
rank() over(order by sum(sales) desc) as sales_rank
from orders
group by customer_id) t;

/* QUESTION 2: Sales Momentum Analysis 
For each customer:

Show current sales

Show previous order sales (based on order_date)

Calculate:

sales_difference

percentage_change from previous order

⚠️ Handle NULL properly (first order has no previous).

👉 Output:

- customer_id

- order_id

- order_date

- sales

- previous_sales

- sales_difference

- percentage_change */

select 
customer_id,
order_id,
order_date,
sales,
previous_sales,
sales - previous_sales as sales_diff,
case 
	when previous_sales is null then null
	when previous_sales = 0 then null
    else round(((sales - previous_sales) / previous_sales)* 100, 2)
    end as percentage_change
from (select customer_id,
order_id,
order_date,
sales,
lag(sales) over(partition by customer_id order by order_date) as previous_sales
from orders) t;

/* Day 4 SQL Challenge — Window Functions (Value Functions Focus) 
Task 1 - Next Order Sales
For each order, show the next order's sales for the same customer.

Expected output columns:

* customerid

* orderid

* orderdate

* sales
* next_sales *
Step-by-Step Explanation
- LEAD() retrieves the next row value within the window - This means show the sales value from the next order 
- Partition by customerid - Each customer is analyzed separately
	The function does not mix orders between customers
- Order by orderdate - This ensures SQL knows the chronological order of purchases */

select customerid,
orderid,
orderdate,
sales,
lead(sales) over(partition by customerid order by orderdate) as next_sales
from salesdb.orders;

/* Task 2 — First Order of Each Customer 
Display each order and also show the first order sales value for that customer.

Expected output:

* customerid

* orderid

* orderdate

* sales

* first_order_sales 
Explanation

- First_value() - Returns the first value in the window frame. 
- PARTITION BY customerid - This separates the calculation per customer.
		- Without it, SQL would return the first order in the entire table.
- ORDER BY orderdate - The earliest order date = first purchase.*/

select customerid,
orderid,
orderdate,
sales,
first_value(sales) over(partition by customerid order by orderdate, orderid) as first_order_sales
from salesdb.orders;

/* Task 3 — Last Order Sales per Customer 
Show each order and also show the latest order sales value of that customer.

Expected columns:
* customerid
* orderid
* orderdate
*sales
* last_order_sales 
Explanation
rows between current row and unbounded following - Look from the current row to the end of the partition.*/

select customerid,
orderid, 
orderdate,
sales,
last_value(sales) over(partition by customerid order by orderdate, orderid rows between current row and unbounded following) as last_sales_value
from salesdb.orders;

/* Task 4 — Maximum Sales per Customer (Without GROUP BY)

Return all orders but also show the maximum sales value each customer ever made.
Explanation
- MAX(sales) - This finds the highest sales value.
- OVER() - Turns the aggregate function into a window function.
		Instead of collapsing rows like GROUP BY, SQL keeps all rows.
- PARTITION BY customerid - This ensures the calculation happens separately for each customer.
	Without this, SQL would calculate the maximum sales of the entire table.*/

select customerid,
orderid,
sales,
max(sales) over(partition by customerid) as max_customer_sales
from salesdb.orders;

/* Task 5 — Compare Order Sales With Customer's Best Order
Show:

* customerid

* orderid

* sales

* max_sales

* difference_from_max */

select *,
max(sales) over(partition by customerid) - sales as difference_from_max 
from (select
customerid, 
orderid,
sales,
max(sales) over(partition by customerid) as max_customer_sales
from salesdb.orders) t;

/* Task 6 — Identify Customer Growth

Compare each order with the previous order.
Explanation
- Step 1 — LAG() gets the previous order sales
- Step 2 — CASE classifies performance */

select *,
case 
	when sales > previous_sales then 'Growth'
    when sales < previous_sales then 'Decline'
    when sales = previous_sales then 'Same'
else 'First Order'
end as performance
from (select customerid,
orderid,
sales,
lag(sales) over(partition by customerid order by orderdate) as previous_sales
from salesdb.orders) t;

/* Day 5: Task 1 — Running Average Sales per Customer
Calculate the running average of sales for each customer ordered by date.
Explanation
- partition by customerid - This resets the calculation for every customer, so each customer has their own running average.
	e.g Customer 1 - running average calculated only on their orders
- order by orderdate - This ensures the average is calculated chronologically 
- window frame - rows between unbounded preceeding and current row
	meaning: from the first order up to the current order.
				so each row includes all previous rows in the average*/

select customerid,
orderid,
orderdate,
sales,
round(avg(sales) over(partition by customerid order by orderdate rows between unbounded preceding and current row), 0) as running_avg_sales
from salesdb.orders;

/* Task 2: Customer Best Order 
Return the highest sale each customer has ever made beside every order
Expected columns:
- customerid
- orderid,
- sales
- best_customer_sale
Explanation
- Max(sales) - This finds the highest sale values
- Over(partition by customerid) - Instead of collapsing rows like a normal group by, the window function keeps all rows while calculating the maximum within each customer group*/

select customerid,
orderid, 
sales,
max(sales) over(partition by customerid) as best_customer_sale 
from salesdb.orders;

/* Task 3: Sales Difference From Customer's Best Order 
Explanation
- Get the customer's best order max(sales) over(partition by customerid - This returns the highest sale value per customer while keeping every row.
- Calculate the difference:
				max(sales) over(partition by customerid) - sales - Meaning: 0 - best order
                positive number - how far the order is from the best*/
select customerid,
orderid,
sales,
max(sales) over(partition by customerid) as best_customer_sale,
max(sales) over(partition by customerid) - sales as diff_from_best
from salesdb.orders;

/* Task 4: Identify the first and last order for each customer 
How this Works
Step 1: Number the orders
		row_number() over(partition by customerid order by orderdate)
Step 2: Count total orders
		count(*) over(partition by customerid)
Step 3: Classify order type*/

select customerid,
orderid,
orderdate,
case 
		when rn = 1 then 'First Order'
        when rn = total_orders then 'Last Order'
        else 'Repeat Order'
end as order_type
from (select customerid,
orderid,
orderdate,
row_number() over(partition by customerid order by orderdate) as rn,
count(*) over(partition by customerid) as total_orders
from salesdb.orders) t; 

/* Task 5: Calculate sales growth compared to the customer's first order.
Explanation 
- first_value(sales) over(partition by customerid order by orderdate):
	This retrieves the first order's sales amount for each customer
- Growth calculation - This shows how much the customer increased spending*/

select *,
sales - first_order_sales as growth_from_first
from (select customerid,
orderid,
sales,
first_value(sales) over(partition by customerid order by orderdate) as first_order_sales
from salesdb.orders) t;

/* Bonus Task: Find the Top 2 highest orders per customer. */
select customerid, 
orderid,
sales,
rank() over(partition by customerid order by sales desc) as sales_rank
from salesdb.orders
;

/* Day 6: Customer Purchase Behavior Analysis 
Question 1: Find the first order each customer made

This helps companies understand customer acquisition behavior.
Explanation 
- row_number() - Window function
- Partition by customer id - splits the table into groups per customer
					Each customer's orders are analyzed separately
- Order by orderdate - Orders the customer's purchases from earliest to latest*/

select customerid,
orderid,
orderdate,
sales
from(select customerid,
orderid,
orderdate,
sales,
row_number() over(partition by customerid order by orderdate) as rn
from salesdb.orders) t
where rn = 1;

/* QUESTION 2: Find the most recent order of each customer 
Explanation 
- Partition by customerid - This splits the data so each customer's orders are analyzed separately 
- Order by orderdate desc - This sorts orders from most recent to oldest
- row_number() - Assigns a sequence number within each customer group
- where rn = 1 - Keeps only the latest order for each customer*/
select *
from(select customerid,
orderid,
orderdate,
sales,
row_number() over(partition by customerid order by orderdate desc) as rn
from salesdb.orders) t
where rn = 1;

/* Question 3: Calculate the days between each customer's orders 
Explanation
- LAG(orderdate) - This retrieves the previous order date for each customer.
					The first order has NULL because there is no previous purchase.
- DATEDIFF() - Calculates the number of days between two orders.
*/
select *,
datediff(orderdate, lag(orderdate) over(partition by customerid order by orderdate)) as days_between_orders 
from(select customerid,
orderid,
orderdate,
lag(orderdate) over(partition by customerid order by orderdate) as previous_order_date
from salesdb.orders) t;

/* Question 4: Identify customers whose order value increased compared to their previous order 
- Explanation
- LAG(sales) - Gets the previous order's sales value for each customer.
- CASE Statement - Compares current sales vs previous sales. */
select *,
case 
	when previous_sales is null then 'First Order'
	when sales > previous_sales then 'Increase'
    when sales < previous_sales then 'decrease'
    when sales = previous_sales then 'Same'
    end as order_trend
from (select customerid,
orderid,
orderdate,
sales,
lag(sales) over(partition by customerid order by orderdate) as previous_sales
from salesdb.orders) t;

/* QUESTION 5: 	Find the highest sales order for each customer 
Explanation 
- PARTITION BY customerid - This separates the data per customer.
- ORDER BY sales DESC - Orders each customer's purchases from highest sales to lowest.
- RANK() - Assigns a rank to each order based on sales amount.
- WHERE sales_rank = 1 - Returns the highest sales order for each customer.
*/
select *
from (select customerid,
orderid,
orderdate,
sales,
rank() over(partition by customerid order by sales desc) as sales_rank
from salesdb.orders) t
where sales_rank = 1;

/* Day 7 SQL Challenge
Question 1 — Customer Lifetime Value
Calculate the total sales for each customer and show only customers whose total sales are above the average customer sales. 
Step by Step
- Calculate Total sales 
- Calculate average customer sales
- Filter customer above average*/


select customerid,
sum(sales) as total_sales
from salesdb.orders
group by customerid
having sum(sales) > (select avg(total_sales) as avg_total_sales
from (select 
sum(sales) as total_sales
from salesdb.orders
group by customerid) avg_table
);

/* Question 2: Calculate total sales per month */

select 
year(orderdate) as year,
month(orderdate) as month,
sum(sales) as total_sales
from salesdb.orders
group by year(orderdate), month(orderdate)
order by year, month
;

/* Question 3: Write a query to find the top 3 products with the highest total sales. 
- Aggregates sales per product
- Ranks product by total sales
Filters top 3 products*/

select *
from (select *,
rank() over(order by total_sales desc) as product_rank
from (select productid,
sum(sales) as total_sales
from salesdb.orders
group by productid) t
) x
where product_rank <= 3;

/* QUESTIOn 4: Find the first order each customer ever placed 
Explanation
- ROW_NUMBER() with PARTITION BY customerid:
	Assigns a unique row number to each order per customer
	Orders the rows by orderdate
- Filter rn = 1 - Keeps only the first order for each customer*/

select customerid,
orderid,
orderdate,
sales 
from (select 
customerid,
orderid,
orderdate,
sales,
row_number() over(partition by customerid order by orderdate) as rn
from salesdb.orders) t
where rn = 1;

/* QUESTION 5: Customer Purchase Gap
Write a query to calculate the number of days between each customer’s orders. */
select *,
datediff(orderdate, previous_order_date) as days_between_orders
from (select orderid,
customerid,
orderdate,
lag(orderdate) over(partition by customerid order by orderdate) as previous_order_date
from salesdb.orders) t
;

/* Day 8: SQL Challenge - Customer & Product Sales Analysis
Assume we have two tables:

Orders Table
orderid	customerid	productid	orderdate	sales
Customers Table

| customerid | customername | region |

Products Table

| productid | productname | category | 

QUESTION 1: Total Sales per customer
Calculate the total sales for each customer and show the customer name and total sales. */

select c.customerid,
c.customername,
sum(sales) as total_sales
from orders as o
	inner join customers as c
		on o.customerid = c.customerid
	group by c.customerid, c.customername;
    
/* QUESTION 2: Find the product that generated the highest total sales. */
select p.productid, 
p.productname,
sum(sales) as total_sales
from products as p
	inner join orders as o
    on p.productid = o.productid
group by p.productid, p.productname
order by total_sales desc
limit 1;

/* Calculate the total sales for each region */
select c.region,
sum(o.sales) as total_sales
from customers as c
	inner join orders as o
    on c.customerid = o.customerid
group by c.region;

/* QUESTION 4: Show customers whose total sales are greater than the average sales of all customers */

select c.customerid,
c.customername,
sum(o.sales) as total_sales
from customers as c
inner join orders as o
	on c.customerid = o.customerid
group by c.customerid, c.customername 
having total_sales > (select avg(customer_total) 
from (select customerid,
sum(sales) as customer_total
from orders
group by customerid) t
);

/* QUESTION 5: Find how many orders were made in each product category */
select p.category,
count(o.orderid) as total_orders
from products as p
	inner join orders as o
		on p.productid = o.productid
group by p.category;

/* Day 9 SQL Challenge: Tables remain the same:

1. customers

- customerid

- customername

- country

2. orders

- orderid

- customerid

- productid

- orderdate

- sales

3. products

- productid

- productname

- category
	
    QUESTION 1: Top 3 customers by total sales 
    Find the top 3 customers who generated the highest total sales.
    Explanation
    - Join the customers and orders tables using customerid to combine customer information with their orders
    - Aggregate the sales using SUM(sales) to calculate the total sales generated by each customer.
    - Group the results by customerid and customername so the total sales are calculated per customer.
    - Sort the results in descending order of total_sales to identify the customers with the highest sales
    - Use limit 3 to return only the top three customers with the highest total sales*/
    
    select c.customerid, 
    c.customername,
    sum(o.sales) as total_sales
    from customers as c
    inner join orders as o
		on c.customerid = o.customerid
	group by customerid, customername
    order by total_sales desc
    limit 3;
    
    /* QUESTION 2: Total Sales Per Category
    Calculate the total sales for each product category.
    Explanation
    - Join the products and orders tables using productid to link each product with its orders.
    - Aggregate the sales using SUM(o.sales) to calculate total sales for each product.
    - Group the results by p.category so the total sales are calculated per category.
    - The output shows each category and its corresponding total sales. */

select p.category,
sum(o.sales) as total_sales
from products as p
inner join orders as o
	on p.productid = o.productid
group by p.category;

/* QUESTION 3: Customers With More Than 5 Orders
Show customers who placed more than 5 orders. 
Explanation
- Use the orders table to get all orders for each customer.
- Count the number of orders per customer using COUNT(orderid)
- Use the HAVING clause to filter only customers who have more than 5 orders.
- The output shows customerid and the total number of orders for each qualifying customer. */

select customerid,
count(orderid) as total_orders
from orders
group by customerid
having total_orders > 5;

/* QUESTION 4: Most Recent Order Per Customer
Show the latest order date for each customer. 
- Use the orders table to get all orders per customer
- Use the MAX(orderdate) function to find the latest order date for each customer
- Group by customerid to ensure one result per customer
- The output shows customerid and their most recent orderdate*/
select customerid,
	max(orderdate) as last_order_date
from orders
group by customerid;

/* QUESTION 5: Products Never Ordered
Find products that have never been ordered
Explanation 
- Start with the products table as the base to include all products
- Perform a LEFT JOIN with the orders table on productid to attach order information where it exists.
- Use the WHERE clause to filter rows where orderid is NULL, meaning the product was never ordered.
- The output shows productid and productname for all products that have no orders. */

select p.productid,
p.productname
from products as p
left join orders as o
	on p.productid = o.productid
where o.orderid is null;

/* QUESTION 6: Highest Sales Order Per Customer 
Find the order with the highest sales per customer 
- Explanation
- Sart with the orders table to access all orders per customer.
- Use the RANK() window function, partitioned by customerid and ordered by sales descending, to rank each customer's orders from highest to lowest sales.
- Wrap this in a subquery to make the sales_rank column available for filtering.
- In the outer query, filter rows where sales_rank = 1 to get the highest sales order(s) for each customer.
- The output shows customerid, orderid, and the sales amount of the top order per customer.*/

select customerid,
orderid,
sales 
from (select customerid,
orderid,
sales,
rank() over(partition by customerid order by sales desc) as sales_rank
from orders) t
where sales_rank = 1;

/* Day 10 SQL Challenge: Assume the tables customers, orders, products. 
QUESTION 1: Customer spending - find the total sales made by each customer
Explanation
- customerid - identifies each customer
- sum(sales) - calculates the total amount spent by the customer
- Group by customerid - groups all orders belonging to the same customer*/

Select customerid,
sum(sales) as total_sales
from orders
group by customerid
order by total_sales desc;

/* Question 2: High Value Customers - Show customers whose total purchases are greater than the average customer sales 
Explanation
- Inner subquery - Calculates total sales for each customer
- Second subquery - Finds the average customer spending
- Main query - Groups sales by customerid
			  Uses Having to filter customers whose total sales exceed the average*/

select customerid,
sum(sales) as total_sales
from orders
group by customerid
having sum(sales) > (select avg(total_sales)
from (select customerid,
sum(sales) as total_sales
from orders
group by customerid) t
);

/* QUESTION 3: Products never ordered - Find products that have never been ordered 
Explanation 
- Left Join - Returns all products from the products table
			- If a product has no matching order, the columns from orders become NULL
- Filter - Keeps only the rows where no order exists*/

Select p.productid,
p.productname
from products as p
left join orders as o
	on p.productid = o.productid
where o.orderid is null;

/* Question 4: Monthly Sales - Calculate total sales for each month 
Explanation
- date_format(orderdate, '%Y - %m) - Extracts the year and month from orderdate.
								   - Example: 2025-03-15 --- 2025-03.
- Sum(sales) - Calculates the total sales for that month
- Group by - Groups all orders belonging to the same month together*/

Select date_format(orderdate, '%Y - %m') as Month,
sum(sales) as  total_sales
from orders
group by date_format(orderdate, '%Y - %m');

/* Question 5: Customer Last Order - Show each customer and the date of their most recent order 
Explanation
- Max(orderdate) finds the latest orderdate
- Group by customerid ensures one result per customer*/
select customerid,
orderdate,
max(orderdate) as last_order_date
from orders
group by customerid;

/* Question 6: Most Expensive Product - Find the product with the highest price 
Explanation 
- Order by price desc - sorts products from highest to lowest price
- Limit 1 - keeps only the top product*/
Select productid,
productname,
price
from products
order by price desc
limit 1;

/* Question 7: Orders per country - show total number of orders per country 
Explanation
- inner join - links each order to the customer who placed it.
- COUNT(orderid) - counts number of orders per country
- Group by c.country - aggregates results by country*/

select c.country,
count(o.orderid) as total_orders
from customers as c
inner join orders as o
	on c.customerid = o.customerid
group by c.country;

/* Question 8: Customers with Multiple Orders - Find customers who have placed more than 3 orders. 
Explanation
- Count(orderid) - Counts how many orders each customer has
- Group by customerid - aggregates the results per customer
- Having count(orderid) > 3 Keeps only those customers who have placed more than 3 orderss*/
select customerid,
count(orderid) as total_orders
from orders
group by customerid
having count(orderid) > 3;

/* Day 11 SQL Challenge 
Assume the tables below exist:

customers

- customerid

- customername

- country

orders

- orderid

- customerid

- productid

- orderdate

- sales

products

- productid

- productname

- category

- price

Question 1 Find the total sales for each customer*/

select customerid,
sum(sales) as total_sales
from orders
group by customerid
;

/* Question 2: Show customers whose total sales are greater than 5000 */
select customerid,
sum(sales) as total_sales
from orders
group by customerid
having total_sales > 5000;

-- Question 3: Find the number of orders placed in each country

select c.country,
count(o.orderid) as total_orders
from orders as o
inner join customers as c
	on c.customerid = o.customerid
group by c.country;

-- Question 4: Find the most expensive product using a subquery

select *
from (select productid,
productname,
price,
rank() over(order by price desc) as price_rank
from products)
where price_rank = 1;

-- Question 5: Find the latest order for each customer 
select customerid,
max(orderdate) as last_order_date
from orders
group by customerid;

-- Question 6: Find the total sales per product category

select p.category,
sum(o.sales) as total_sales
from orders as o
inner join products as p
	on o.productid = p.productid
group by p.category;

-- Question 7: Find customers who placed more than 3 orders

select customerid,
count(orderid) as total_orders
from orders
group by customerid
having count(orderid) > 3;

/* Question 8: Find orders placed in the last 30days 
Explanation
- current_date - today's date
- interval '30 days' - subtracts 30 days
- Where orderdate >= only keeps orders from the last 30 days*/

/*
select customerid,
orderid,
orderdate
from orders 
where orderdate >= cur - interval '30 days';*/

-- Question 9: Find products that were never ordered

select p.productid,
p.productname
from products as p
left join orders as o
	on o.productid = p.productid
where o.orderid is null;

-- Find the average sales value of all orders

select avg(sales) as average_sales 
from orders;

/* Day 12 SQL Challenge (Advanced Mix) 
Assume these tables:

customers

- customerid

- customername

- country

orders

- orderid

- customerid

- productid

- orderdate

- sales

products

- productid

- productname

- category

- price

QUESTION 1: Customer Total Sales (CTE)
Using a CTE, calculate the total sales for each customer 

 Question 2: Customer Ranking 
Using the result from Question 1:

Rank customers based on total_sales (highest first). 

*/

with customer_total as (select customerid,
sum(sales) as total_sales
from salesdb.orders
group by customerid
)
, customer_rank as (
select customerid,
total_sales,
rank() over(order by total_sales desc) as sales_rank
from customer_total
)
-- Main Query
select c.customerid,
c.customername,
ct.total_sales,
cr.sales_rank
from salesdb.customers as c
left join customer_total as ct
	on c.customerid = ct.customerid
left join customer_rank as cr
	on c.customerid = cr.customerid
left join top_customer as tp
	on c.customerid = tp.customerid;


 /* Question 3: Top Customer Per Country
Find the top customer in each country based on total sales */

with customer_total as (select customerid,
sum(sales) as total_sales
from salesdb.orders
group by customerid
)
, customer_country_rank as (
select c.customerid,
c.customername,
c.country,
ct.total_sales,
rank() over(partition by c.country order by ct.total_sales desc) as country_rank
from salesdb.customers as c
join customer_total as ct
	on c.customerid = ct.customerid
)

-- Main Query

select *
from customer_country_rank
where country_rank = 1;

/* Question 4: customer Last Order 
Find the most recent order for each customer*/

select *
from (select customerid,
orderid,
orderdate,
rank() over(partition by customerid order by orderdate desc) as rn
from salesdb.orders) t
where rn = 1;

/* Question 5: Product sales by category 
Calculate the total sales per product category */

select category,
sum(sales) as total_sales
from salesdb.products as p
join salesdb.orders as o
	on p.productid = o.productid
group by category;

/* Question 6: Best selling product per category 
Find the best product with the highest sales in each category */

with best_selling_product as (select p.productid,
p.product,
p.category,
o.sales,
rank() over(partition by category order by o.sales desc) as sales_rank
from salesdb.products as p
join salesdb.orders as o
	on p.productid = o.productid
)
select *
from best_selling_product
where sales_rank = 1;

/* Question 7: Orders Above Customer Average 
show orders where the sales value is greater than the customer's average order sales	*/

with customers_average as (select customerid,
avg(sales) as customers_average_sales
from salesdb.orders
group by customerid)
select c.customerid,
o.orderid,
o.sales
from salesdb.orders as o
join customers_average as c
	on o.customerid = c.customerid
where o.sales > customers_average_sales;

/* Question 8: Customer Order Gap 
Calculate the number of days between each customer's orders */

select customerid,
orderid,
orderdate,
lag(orderdate) over(partition by customerid order by orderdate) as previous_order_date,
datediff(orderdate,lag(orderdate) over(partition by customerid order by orderdate) ) as days_between_orders
from salesdb.orders;

/* Question 9: Customers with no orders 
Find customers who never placed an order */

select c.customerid,
concat(firstname, ' ', lastname) as customername,
o.orderid
from salesdb.customers as c
left join salesdb.orders as o
	on c.customerid = o.customerid
where o.orderid is null;

/* Day 13 SQL Challenge 
Question 1: Orders above average 
Find orders where the sales value is greater than the average sales of all orders*/

select orderid,
customerid,
sales
from salesdb.orders
where sales > (select avg(sales) 
from salesdb.orders);

/* Question 2: Customer Total Sales 
Calculate the total sales for each customer*/

select customerid,
sum(sales) as total_sales
from salesdb.orders 
group by customerid;

/* Question 3: Top Spending Customer
Find the customer with the highest total sales */
select customerid,
sum(sales) as total_sales
from salesdb.orders 
group by customerid
order by total_sales desc
limit 1;

/* Question 4: Customers with no orders
Show customers who have never placed any orders */

select c.customerid,
c.firstname,
c.lastname
from salesdb.customers as c
left join salesdb.orders as o
	on c.customerid = o.customerid
where o.orderid is null;

/* Question 5: Customers Order Ranking 
Rank each customer's orders by sales amount(highest first)*/
select customerid,
orderid,
sales,
rank() over(partition by customerid order by sales desc) as sales_rank
from salesdb.orders;

/* Question 6: Highest Order Per Customer 
Find the highest sales order for each customer*/
select customerid,
orderid,
sales
from (select customerid,
orderid,
sales,
row_number() over(partition by customerid order by sales desc) as rn
from salesdb.orders) t
where rn = 1;

/* Question 7: Orders in last 30 days 
Find all orders placed in the last 30 days*/

select orderid,
customerid,
orderdate
from salesdb.orders
where orderdate >= current_date - interval 30 day;

/* Question 8: Customers with more than 3 orders
Show customers who placed more than 3 orders */

select customerid,
count(orderid) as total_orders
from salesdb.orders
group by customerid
having count(orderid) > 3; 

/* Question 9: Products never ordered 
Find products that have never appeared in any order. */

select p.productid,
p.product
from salesdb.products as p
left join salesdb.orders as o
	on p.productid = o.productid
where o.orderid is null;

/* Question 10: Running Total Sales 
Calculate a running total of sales ordered by order date*/

select orderid,
orderdate,
sales,
sum(sales) over(order by orderdate) as running_total
from salesdb.orders;

/* Day 14: SQL Challenge 
Question 1: Customer Total Sales */

select customerid,
sum(sales) as total_sales
from salesdb.orders
group by customerid;

/* Question 2: Highest Order Per Customer 
Show the highest sales order for each customer */
select *
from (select customerid,
orderid,
sales,
row_number() over(partition by customerid order by sales desc) as rn
from salesdb.orders) t
where rn = 1;

/* Question 3: Top 3 Orders by Sales 
Return the top 3 orders with the highest sales. */

select orderid,
customerid,
sales
from salesdb.orders 
order by sales desc
limit 3;

/* Question 4: Customer Sales Rank 
Rank customers based on their total sales (highest sales get rank 1) */

select customerid,
total_sales,
rank() over(order by total_sales desc) as sales_rank
from (select customerid,
sum(sales) as total_sales
from salesdb.orders
group by customerid) t;

/* Question 5: Orders above overall average
Return orders where sales is greater than the overall average sales */

select orderid,
customerid,
sales
from salesdb.orders
where sales > (
select avg(sales)
from salesdb.orders);

/* Question 6: Customer Order Gap
Find the number of days between a customer's current order and their previous order. */

select customerid,
orderid,
orderdate,
lag(orderdate) over(partition by customerid order by orderdate) as previous_order_date,
datediff(orderdate, lag(orderdate) over(partition by customerid order by orderdate)) as days_between_orders
from salesdb.orders;

/* Question 7: Customers with more than 5 orders 
Show customers who have placed more than 5 orders */

select customerid,
count(orderid) as total_orders
from salesdb.orders 
group by customerid
having count(orderid) > 5;

/* Question 8: Running Sales Per Customer 
Show a running total of sales per customer ordered by order date*/

select customerid,
orderid,
orderdate,
sales,
sum(sales) over(partition by customerid order by orderdate) as running_total
from salesdb.orders;

/* Question 9: First Order per customer 
Find the first order placed by each customer*/
select customerid,
orderid,
orderdate
from (select customerid,
orderid,
orderdate,
row_number() over(partition by customerid order by orderdate) as rn
from salesdb.orders) t
where rn = 1;

/* Question 10: Customers Above Average Total Sales 
Find customers whose total sales are greater than the average total sales of all customers
*/

select customerid,
total_sales 
from (select customerid,
sum(sales) as total_sales
from salesdb.orders
group by customerid ) x 
where total_sales > 
(select avg(total_sales) 
from (select customerid,
sum(sales) as total_sales
from salesdb.orders
group by customerid) t
);

/* Day 15: SQL Challenge 
Question 1: Customers with above average total sales*/

select customerid,
total_sales
from (select customerid,
sum(sales) as total_sales
from orders
group by customerid) x
where total_sales > 
(select avg(total_sales)
from (select customerid,
sum(sales) as total_sales
from orders
group by customerid) t
);

/* Question 2: Customer's First Order 
Show the first order placed by each customer. 
Explanation 
- Window Function - Does two things
				- Partition by customerid - splits the data into groups for each customer
                - Order by orderdate - Orders the customer's orders from earliest to latest
				- row_number() - Assigns numbers starting from 1 for each customer
- where rn = 1 -- This correctly returns first order for each customer*/

select customerid,
orderid,
orderdate
from (select customerid,
orderid,
orderdate,
row_number() over(partition by customerid order by orderdate) as rn
from orders) t
where rn = 1;

/* Question 3: Top product by total sales
Find the product that generated the highest total sales. */

select p.productid,
sum(sales) as total_sales
from products as p
join orders as o
	on p.productid = o.productid
group by p.productid
order by total_sales desc
limit 1;

/* Question 4: Customers with No Ordes 
List customers who have never placed an order. */

select c.customerid,
c.firstname,
c.lastname,
o.orderid
from customers as c
left join orders as o
	on c.customerid = o.customerid
where o.orderid is null;

/* Question 5: Running total sales per customer
Calculate the running total of sales for each customer ordered by date. 
Explanation 
- Partition the data by customer - This means the running total is calculated separately for each customer
- Order the rows - Orders are arranged from earliest to latest before calculating the running total*/

select customerid,
orderdate,
sales,
sum(sales) over(partition by customerid order by orderdate) as running_total
from orders;

/* Question 6: Last order per customer 
Find the last order date for each customer. 
Explanation 
- Group Orders by customer - This group all orders belonging to the same customer together
- Max() - returns the most recent orderdate for each customer*/

select customerid,
max(orderdate) as last_order_date
from orders
group by customerid;

/* Question 7: Rank customers by total sales 
Rank customers based on their total sales(highest first) 
Explanation 
- Calculate total sales per customer - THis calculates the total sales for each customer
- Apply ranking - This ranks customers from highest sales to lowest sales*/
select customerid,
total_sales,
rank() over(order by total_sales desc) as sales_rank
from (select customerid,
sum(sales) as total_sales
from orders
group by customerid) t;

/* Question 8: Orders higher than customer average
Show orders where the sales value is greater than that customer's average order sales. */

select customerid,
orderid,
sales
from orders o
where sales > (select avg(sales)
from orders as o
where customerid = o.customerid);

/* Question 9: Product sales summary 
Show total sales per product 
Explanation
- Join products and orders - This connects each product with the orders that contain it
- Calculate total sales - Adds all sales values for that product
- Count total orders - Counts how many orders included that product*/

select p.productid,
sum(sales) as total_sales,
count(o.orderid) as total_orders
from products as p
join orders as o
	on p.productid = o.productid
group by productid;

/* Question 10: Customer Segmentation 
Segment customers based on total sales 
Explanation 
- Calculate total sales per customer - Groups all orders for each customer and sums the sales
- Segment customers using case */

select customerid,
total_sales,
case 
	when total_sales > 100 then 'VIP' 
    when total_sales between 60 and 90 then 'Regular'
    else 'Low value'
    end as customer_segment 
from (select customerid,
sum(sales) as total_sales
from orders
group by customerid) t
