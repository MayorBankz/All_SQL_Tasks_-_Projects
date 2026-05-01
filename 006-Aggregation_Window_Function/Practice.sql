/* Aggregation tasks 
Question 1: Find the total sales of all orders */

select sum(sales) as total_sales
from orders;

-- Question 2: Find the average sales of all orders 

select avg(sales) as avg_sales
from orders;

-- Question 3: Find the total number of orders 

select count(*) as total_orders
from orders;

-- Question 4: Find the highest sales of all orders

select max(sales) as max_sales
from orders
;

-- Question 5: Find the lowest score among customers

select min(score) as min_score
from customers;


/* Aggregation & Window function tasks */

-- Question 1 : Find the total sales across all orders

select sum(sales) as total_sales
from orders;

/* Question 2: Find the total sales for each product
Explanation 
- Sum(sales) - Adds sales values
- Over() - Turns it into a window function.
- PARTITION BY productid - Groups rows by each product.
- it calculates total sales per product without collapsing rows
 */

select productid, 
sum(sales) over(partition by productid) as total_sales
from orders;

/* Question 3: Find the total sales for each product, additionally provide details such orderid & orderdate
Explanation 
- orderid, orderdate, productid - Show individual order details
- Sum(sales) over(partition by productid) - Calculates total sales for each product
- Partition by productid - Groups rows logically by product.
- The window function does not collapse rows */
select orderid, 
orderdate,
productid,
sum(sales) over(partition by productid) as total_sales
from orders;

/* Question 4: Find the total sales across all orders, additionally provide details such as orderid & orderdate
Explanation
- sum(sales) - Adds all sales values
- over() - Makes it a window function
- over() without Partition by - Calculates the total across the entire table
- It does not collapse rows */
select orderid,
orderdate,
sum(sales) over() as total_sales
from orders;

/* Question 5: Find the total sales for each combination of product and order status, additionally provide details such as orderid, orderdate
Explanation
- Group rows by product
- Then further divide by orderstatus
- Calculate total sales within each unique combination */

select orderid, 
orderdate,
productid,
orderstatus,
sum(sales) over(partition by productid, orderstatus) as total_sales
from orders;

/* Question 6: Rank each order based on their sales from highest to lowest, additionally provide details such as orderid & orderdate 
- SELECT orderid, orderdate, sales - displays order details.
- RANK() OVER (ORDER BY sales DESC) - Assigns ranking based on sales.
									- DESC ensures highest sales get Rank 1
- AS sales_rank - Names the ranking column*/
select orderid,
orderdate,
sales,
 rank() over(order by sales desc) as sales_rank
from orders;

/* Question 7: Find the total sales for each order status, only for two products 101 and 102 
Explanation
- Where productid in (101,102) - filters the data to include only products 101 and 102
- SUM(sales) OVER (PARTITION BY orderstatus) - Calculates the total sales for each orderstatus
- Partition by orderstatus - Groups the calculation by order status without collapsig rows.
- The query keeps all individual rows and displays the total slaes per status alongside each row
*/
select orderstatus, productid, sales,
sum(sales) over(partition by orderstatus) as total_sales
from orders
where productid in (101,102);

/* Question 8: Rank customers based on their total sales
Explanation
- Group by customerid - combines all orders belonging to the same customer
- SUM(sales) - calculates each customer's total sales
- Rank() over(order by sum(sales) desc) - Ranks customers from highest to lowest total sales.
If two customers have the same total sales, they receive the same rank, and the next rank is skipped*/
select customerid,
sum(sales) as total_sales,
rank() over(order by sum(sales) desc) as customer_rank
from orders
group by customerid;
