# MySQL-JOINS_AND_SET_OPERATORS
## Intermediate MySQL examples covering JOJNs and SET operators with real-world use cases 
## DATE - 03-02-2026


### MySQL JOINS and SET operators (Intermediate - Level 2)

This document provides a structured set of MySQL queries demonstrating how to combine data using <b>JOINS</b> and <b>SET</b> operators. It is designed for intermediate learners and practical business use cases.

--- 

📌 Assumptions

* `customers.id` (or `customers.customerid`) is the primary key of the customers table

* `orders.customer_id` (or `orders.customerid`) is a foreign key referencing customers

* Column names may vary slightly depending on your schema

---

🧩 Section 1: Combining Data Using JOINs

### QUESTION 1: Retrieve all data from customers and orders as separate results

```sql
SELECT *
FROM customers
;

SELECT *
FROM orders
;
```

✔ Returns two independent result sets.

---

### QUESTION 2: Retrieve all customers along with their orders (only customers who placed orders)

```sql
SELECT *
FROM customers AS c
INNER JOIN orders AS o
  on c.id = o.customer.id
;

```
Uses an `INNER JOIN` to return only matching records.

---

### QUESTION 3: Retrieve all customers along with their orders, including customers without orders
``` sql
SELECT *
FROM customers as c
  LEFT JOIN orders as o
      on c.id = o.customer_id
```

✔ Returns all customers, with `NULL` values for customers without orders.

--- 

### QUESTION 4: Retrieve all customers along with their orders, including orders without matching customers

```sql
SELECT *
FROM customers AS c
  RIGHT JOIN orders as o
      on c.id = o.customer_id
```

✔ Returns all orders, even if no matching customer exists.

---

### QUESTION 5: Retrieve customers who have not placed any order

```sql

SELECT *
FROM customers as c
LEFT JOIN orders as o
`   on c.id = o.customer_id
where o.customer_id is NULL
;
```

✔ Uses `LEFT JOIN` with `NULL` filtering (anti-join pattern).

---

### QUESTION 6: Retrieve orders without matching customers

```sql
SELECT *
FROM customers as c
RIGHT JOIN orders as o
    on c.id = o.customer_id
where c.id is NULL
;
```

✔ Identifies orphan records in the orders table.

---

### QUESTION 7: Retrieve customers with orders without using INNER JOIN

```sql
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
  on c.id = o.customer_id
where o.customer_id is NOT NULL
;
```

✔ Functionally equivalent to an INNER JOIN.

---

### QUESTION 8: Retrieve orders with customer, product, and employee details (SalesDB)

Required Output:
* OrderID
* Customer name
* Product name
* Sales anount
* Product price
* Salesperson name

```sql
SELECT
o.orderid,
o.sales AS sales_amount,
c.firstname AS customer_first_name,
c.lastname AS customer_last_name,
p.product AS product_name,
p.price AS product_price,
e.firstname AS employee_first_name,
e.lastname AS employee_last_name
FROM customers AS c
INNER JOIN orders AS o
ON c.customerid = o.customerid
INNER JOIN products AS p
ON o.productid = p.productid
INNER JOIN employees AS e
ON e.employeeid = o.salespersonid;
```

✔ Demonstrates multi-table joins commonly used in reporting and analytics.

---

🔁 Section 2: Set Operator Tasks

### QUESTION 1: Combine employees and customers into one result set (remove duplicates)

```sql
SELECT firstname, lastname
fROM customers
UNION
SELECT firstname, lastname
FROM employees
;
```

✔ `UNION` removes duplicate rows.

---

### QUESTION 2: Combine employees and customers into one result set (include duplicates).

```sql
SELECT firstname, lastname
FROM customers
UNION ALL
SELECT firstname, lastname
FROM employees
;
```

✔ UNION ALL retains duplicate records.

---

✅ Summary

* Demonstrates practical use of `INNER`, `LEFT`. `RIGHT`, and `CROSS` joins
* Covers common anti-join patterns using `NULL` filtering
* Shows how to use `UNION` and `UNION ALL` effectively.
