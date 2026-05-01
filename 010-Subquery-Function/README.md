# SQL SUBQUERY PRACTICE
## TOOL - MySQL
## DATE - 11/03/2026

---

### OVERVIEW
This project contains practice SQL queries focused on Subqueries using a sample sales database.

Subqueries allow us to run a query inside another query.
The result of the inner query is then used by the outer query to filter or analyze data.

The exercises below demonstrate how subqueries can be used in:
* `WHERE` clause
* `FROM` clause (Derived Tables)
* `IN` and `NOT IN`
* `ANY`
* `EXISTS`
* Aggregations with `GROUP BY`
* Window Functions

**Database Used: salesdb**

---

📊 Tables Used

## Produccts
| **Column** | **Description** |
| ---------- | --------------- |
| Productid | Unique product ID |
| Product | Productname |
| Price | Product price |

### Orders

| Column     | Description                   |
| ---------- | ----------------------------- |
| orderid    | Order ID                      |
| customerid | Customer who placed the order |
| productid  | Product ordered               |
| orderdate  | Date of order                 |
| sales      | Sales value                   |

### Customers

| Column       | Description        |
| ------------ | ------------------ |
| customerid   | Unique customer ID |
| customername | Name of customer   |
| country      | Customer location  |

### Employees

| Column     | Description        |
| ---------- | ------------------ |
| employeeid | Employee ID        |
| gender     | Gender of employee |
| salary     | Employee salary    |

---

# 🧠 What is a Subquery?

A **Subquery** is a query written **inside another SQL query**.

The **inner query runs first**, and the **outer query uses its result**.

Example structure:

```sql
SELECT column_name
FROM table
WHERE column_name IN (
    SELECT column_name
    FROM another_table
);
```

---

# 📝 Practice Questions & Solutions

---

# 1️⃣ Products With Price Higher Than Average

### Task

Find products whose price is **higher than the average price of all products**.

### SQL Query

```sql
SELECT productid, product, price
FROM salesdb.products
WHERE price > (
    SELECT AVG(price)
    FROM salesdb.products
);
```

### Explanation

1. The subquery calculates the **average product price**.
2. The outer query compares each product's price with that average.
3. Only products **above the average price** are returned.

---

# 2️⃣ Rank Customers Based on Total Sales

### Task

Rank customers based on their **total sales amount**.

### SQL Query

```sql
SELECT customerid,
customer_total,
RANK() OVER (ORDER BY customer_total DESC) AS sales_rank
FROM (
    SELECT customerid,
    SUM(sales) AS customer_total
    FROM salesdb.orders
    GROUP BY customerid
) t;
```

### Explanation

1. The subquery calculates **total sales per customer**.
2. This result becomes a **temporary table (derived table)**.
3. The outer query applies the **RANK() window function** to rank customers.

---

# 3️⃣ Show Products With Total Number of Orders

### Task

Show product ID, product name, price, and the **total number of orders**.

### SQL Query

```sql
SELECT p.productid,
p.product,
p.price,
t.total_orders
FROM salesdb.products p
JOIN (
    SELECT productid,
    COUNT(orderid) AS total_orders
    FROM salesdb.orders
    GROUP BY productid
) t
ON p.productid = t.productid;
```

### Explanation

1. The subquery counts **orders per product**.
2. The outer query joins that result with the **products table**.
3. This allows us to display **product information with order counts**.

---

# 4️⃣ Show Customers and Their Total Orders

### Task

Display **all customers and their total orders**.

### SQL Query

```sql
SELECT *
FROM salesdb.customers s
LEFT JOIN (
    SELECT customerid,
    COUNT(orderid) AS total_orders
    FROM salesdb.orders
    GROUP BY customerid
) t
ON s.customerid = t.customerid;
```

### Explanation

* The subquery counts **orders per customer**.
* A **LEFT JOIN** ensures that customers with **no orders are still shown**.

---

# 5️⃣ Products Above Average Price (Reinforcement)

### SQL Query

```sql
SELECT productid, product, price
FROM salesdb.products
WHERE price > (
    SELECT AVG(price)
    FROM salesdb.products
);
```

### Purpose

Reinforces understanding of **subqueries in the WHERE clause**.

---

# 6️⃣ Orders Made by Customers in Germany

### SQL Query

```sql
SELECT *
FROM salesdb.orders
WHERE customerid IN (
    SELECT customerid
    FROM salesdb.customers
    WHERE country = 'Germany'
);
```

### Explanation

1. The subquery gets **customers located in Germany**.
2. The outer query returns **orders belonging to those customers**.

---

# 7️⃣ Orders Made by Customers Outside Germany

### SQL Query

```sql
SELECT *
FROM salesdb.orders
WHERE customerid NOT IN (
    SELECT customerid
    FROM salesdb.customers
    WHERE country = 'Germany'
);
```

### Explanation

This query returns **orders made by customers who are not located in Germany**.

---

# 8️⃣ Female Employees Earning More Than Male Employees

### SQL Query

```sql
SELECT *
FROM salesdb.employees
WHERE gender = 'F'
AND salary > ANY (
    SELECT salary
    FROM salesdb.employees
    WHERE gender = 'M'
);
```

### Explanation

* The subquery returns **salaries of male employees**.
* `ANY` compares female salaries with those values.
* It returns females earning **more than at least one male employee**.

---

# 9️⃣ Customers With Total Orders

### SQL Query

```sql
SELECT *
FROM salesdb.customers c
LEFT JOIN (
    SELECT customerid,
    COUNT(orderid) AS total_orders
    FROM salesdb.orders
    GROUP BY customerid
) t
ON c.customerid = t.customerid;
```

This shows **each customer and how many orders they made**.

---

# 🔟 Orders From Customers in Germany (Derived Table Method)

```sql
SELECT *
FROM salesdb.orders o
JOIN (
    SELECT customerid, country
    FROM salesdb.customers
    WHERE country = 'Germany'
) t
ON o.customerid = t.customerid;
```

---

# 🔟 Orders From Customers in Germany (EXISTS Method)

```sql
SELECT *
FROM salesdb.orders o
WHERE EXISTS (
    SELECT 1
    FROM salesdb.customers c
    WHERE c.customerid = o.customerid
    AND c.country = 'Germany'
);
```

---

# 🎯 Skills Practiced

* Subqueries in `WHERE`
* Subqueries in `FROM`
* Derived tables
* `IN` and `NOT IN`
* `ANY`
* `EXISTS`
* Aggregations (`SUM`, `COUNT`, `AVG`)
* Window functions (`RANK()`)

---

# 🚀 Learning Outcome

Through these exercises, I practiced how to:

* Use **subqueries to filter and analyze data**
* Combine **aggregations with subqueries**
* Use **derived tables to simplify complex queries**
* Apply **advanced filtering techniques**

---

✅ This forms part of my **SQL Practice & Data Analytics Portfolio**.



| **Column** | **Description** | 
| ---------- | ----------- |
| Orderid 

