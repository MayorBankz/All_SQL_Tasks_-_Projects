/* IFNULL and COALESCE Tasks 
QUESTION 1: Find the average scores of the customers 
Explanation 
Some customers have NULL scores, which can affect the average calculation.

- IFNULL(score, 0) - Converts NULL scores to `0`
- AVG() - Calculates the average including those replaced values
- Result - a safe and accurate average score
*/

select avg(ifnull(score, 0)) as avg_score
from customers
;

/* QUESTION 2: Display the full name of customers in a single field by merging their first and last names, and 10 bonus points to each customer's score
*/

select *
from customers
;

select concat(firstname, ' ', ifnull(lastname, '')) as fullname, coalesce(score, 0) + 10 as bonusscore
from customers
;

/* QUESTION 3: Sort the customers from lowest to highest scores, with NULLs appearing last */

select firstname, lastname, ifnull(score, 999999) as score
from customers
order by score
;

/* NULLIF Tasks
Question 1: Find the sales price for each order by dividing the sales by the quantity */

select orderid, sales / NULLIF(quantity, 0) as sales_price
from orders
;

/* IS NULL, IS NOT NULL Tasks
QUESTION 1 - Identify the customers who have no scores */

select customerid, score
from customers
where score is null
;

-- QUESTION 2 List all customers who have scores 

select customerid, score
from customers
where score is not null
;

/* QUESTION 3: List all details for customers who have not placed any orders
How this works
1. LEFT JOIN - Returns all customers, even if they have no orders
2. Where o.customreid IS NULL - filters only customers without matching orders
O/P: Customers who have never placed an order*/
select *
from customers as c
left join orders as o
	on c.customerid = o.customerid
where o.customerid is null
;

select *
from orders
