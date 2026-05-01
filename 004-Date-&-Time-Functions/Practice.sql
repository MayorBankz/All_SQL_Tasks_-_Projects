/* String Function Tasks
QUESTION 1: Concatenate first name and country into one column */

select first_name, country, concat(first_name, ' ', country) as concat
from mydatabase.customers
;

-- QUESTION 2: Convert the firstname to lowercase

select first_name, lower(first_name)
from mydatabase.customers
;

-- QUESTION 3: Convert the first name to uppercase

Select first_name, upper(first_name)
from mydatabase.customers
;

-- QUESTION 4: Find customers whose first name contains leading or trailing spaces

select first_name
from mydatabase.customers
where first_name != trim(first_name)
;

-- QUESTION 5: Replace the file 'report.txt' from txt to 'csv'

select replace('report.txt', 'txt', 'csv');

-- QUESTION 6: Calculate the length of each customers first name

select first_name, length(first_name)
from mydatabase.customers
;

-- QUESTION 7: Retrieve the first two characters of each first name

select first_name, left(first_name, 2)
from mydatabase.customers
;

-- QUESTION 8: Retrieve the last two characters of each first name 

select first_name, right(first_name, 2)
from mydatabase.customers
;

-- QUESTION 9: Retrieve a list of customers first names removing the first character

select first_name, substring(first_name, 2)
from mydatabase.customers
;

/* Date and Time functions Task (Aggregation)
Question 1: How many orders were placed each year */

select year(orderdate) as ord_year, count(quantity)
from salesdb.orders
group by ord_year
;

-- QUESTION 2: How many orders were placed each month

select monthname(orderdate) as monthly_order, count(quantity)
from salesdb.orders
group by monthly_order
;

/* Data Filtering 
QUESTION 1: Show all orders that were placed during the month of February */

select monthname(orderdate) as monthly_order, count(quantity)
from salesdb.orders
where monthname(orderdate) = 'February'
group by monthly_order
;

/*QUESTION 2: Show creationTime using the following format: Day Wed Jan Q1 2025 12:34:56
 To display creationTime in the format: Day Wed Jan Q1 2025 12:34:56
 - Use DATE_FORMAT, QUARTER, and CONCAT
 HOW THIS WORKS 
 - %a - abbreviated weekday(wed)
 - %b - abbreviated month (Jan)
 - QUARTER(Creationtime) - quarter of the year (Q1)
 - %Y - Year (2025)
 - %H:%i:%s - time (12:34:56)
 - Day and Q are added as literal text using concat*/
 
SELECT 
  CONCAT(
    'Day ',
    DATE_FORMAT(creationTime, '%a %b '),
    'Q', QUARTER(creationTime), ' ',
    DATE_FORMAT(creationTime, '%Y %H:%i:%s')
  ) AS formatted_creationTime
FROM orders;

/* DATEDIFF() TASKS
To calculate the age of employees, the employee's date of birth is used
EXPLANATION
- TIMESTAMPDIFF(YEAR, birthdate, curdate()) calculates the completed years between birth date and today.
- CURDATE() returns the current date 
QUESTION 1: Calculate the age of employees */

select employeeid, birthdate, timestampdiff(year, birthdate, curdate()) as current_age
from employees;

/* QUESTION 2: Find the average shipping duration in days for each month
- To find the average shipping duration (in days) for each month, calculate the difference between shipdate and orderdate, then aggregate by month
 Brief Explanation
 - DATEDIFF(shipdate, orderdate) - Shipping duration in days
 - AVG (...) - average shipping duration
 - Grouping by YEAR and MONTH ensures each month is calculated correctly across years	
 - WHERE shipdate IS NOT NULL avoids invalid calculations */
 
select 
year(orderdate) as order_year,
month(orderdate) as order_date,
avg(datediff(shipdate, orderdate))as avg_shipping_days
from orders
where shipdate is not null
group by 
year(orderdate),
month(orderdate)
order by 
order_year, 
order_date;

select *
from orders
;

/* QUESTION 3: Find the number of days between each order and previous order
Solution
- To find the number of days between each order and the previous order, you can use a window function (LAG) together with a DATEDIFF. 
Explanation
- LAG(orderdate) gets the previous order's date
- DATEDIFF(current_date, previous_date) calculates the difference in days
- The first order will return NULL since there is no previous order
*/

select orderid, 
orderdate, 
datediff(orderdate, lag(orderdate) over(order by orderdate)
) as days_between_orders
from orders
order by orderdate;


