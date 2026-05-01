/* Combining Data 
Joins Task (Intermediate - Level 2)
Question 1: Retrieve all data from customers and orders as separate results
*/

select *
from customers;

select *
from orders ;


-- Question 2: Get all customers along with their orders, but only for customers who have placed an order.

select *
from customers as c
join orders as o
	on c.id = o.customer_id
;

-- Question 3: Get all customers along with their orders, including those without orders.

select *
from customers as c
left join orders as o
	on c.id	= o.customer_id
;

-- Question 4: Get all customers along with their orders, including orders without matching customers

select *
from customers as c
right join orders as o
	on c.id = o.customer_id
;

-- Question 5: Get all customers who haven't placed any order

select *
from customers as c
left join orders as o
	on c.id = o.customer_id
where o.customer_id is null
;

-- Question 6: Get all orders without matching customers

select *
from customers as c
right join orders as o
	on c.id = o.customer_id
where c.id is null
;

-- Question 7: Get all customers along with their orders, but only for customers who have placed an order (Without using INNER JOIN)

select *
from customers as c
left join orders as o
	on c.id = o.customer_id
where o.customer_id is not null;

-- Question 8: Generate all possible combinations of customers and orders

select *
from customers as c
cross join orders as o
;

/* Question 9: Using SalesDB, retrieve a list of all orders, along with the related customer, product, and employee details. For each order, display 
- Order ID
- Customer's name
- Product name
- Sales amount
- Product price
- Salesperson's name*/

select o.orderid, o.sales, c.firstname as customerFirstName, c.lastname as customerLastName, p.product as productname, p.price, e.firstname as employeeFirstName, e.lastname as EmployeeLastName
from customers as c
inner join orders as o
	on c.customerid = o.customerid
inner join products as p
	on o.productid = p.productid
inner join employees as e
	on e.employeeid = o.salespersonid
    ;
    
/* Set operator tasks (Union, Union all, except, intersect)
QUESTION 1: Combine the data from employees and customers into one table */

select *
from customers;

select *
from employees;

select firstname, lastname
from customers
union
select firstname, lastname
from employees
;

-- Question 2: Combine the data from employees and customers into one table, including duplicates

select firstname, lastname
from customers
union all
select firstname, lastname
from employees;


 
    
