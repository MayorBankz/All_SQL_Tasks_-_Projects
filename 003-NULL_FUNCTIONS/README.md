# SQL_NULL_Functions_Practice-MySQL-
## Practical exercises on NULL functions
## DATE: 13-02-2026
## TOOL: MySQL
---
### OVERVIEW 

This repository contains practical SQL exercises focused on handling NULL values using MySQL functions. The goal is to demonstrate how NULLs affect calculations, sorting, joins, and data accuracy in real-world datasets.

---

📌 TOPICS COVERED
* `IFNULL()`
* `COALESCE()`
* `NULLIF()`
* `IS NULL / IS NOT NULL`
* Handling NULLs in:
  - Aggregations
  - String Concatenation
  - Sorting
  - Joins
  - Mathematical Operations

---

📁 Tables

### CUSTOMERS 

| COLUMN | DESCRIPTION |
| ------ | ----------- |
| Customerid | Unique customerid |
| firstname | Customer first name |
| lastname | Customer last name |
| Country | Customer's country |
| Score | Customer score (can be NULL) |

---

### ORDERS
| Column Name | Description |
| ----------- | ----------- |
| Orderid | Unique Order id |
| Productid | Unique Product id |
| Customerid | Customer id |
| Salespersonid | Unique id of salesperson |
| Orderdate | Date order is placed |
| shipdate | Date order is shipped |
| orderstatus | status of the order |
| shipaddress | The address the order is to be shipped to |
| billadress | billing address of the customer |
| quantity | Quantity ordered (can be 0 or NULL) |
| Sales | sales made | 
| Creationtime | Date order was created |

---

### IFNULL & COALESCE Tasks
Question 1: Find the average customer score 
Some customers have have `NULL` scores. These are converted to `0` before calculating the average.

```sql
SELECT AVG(IFNULL(score, 0)) AS avg_score
FROM customers;
```

Explanation
* `IFNULL(Score, 0)` replaces NULL scores with `0`
* `avg()` calculates the average including replaced values
* Useful when business rules require treating missing scores as zero
  
---

### QUESTION 2: Display full name and add bonus points 

Merge first and last names into one field and add 10 bonus points to each customer's score

```sql
SELECT 
    CONCAT(firstname, ' ', IFNULL(lastname, '')) AS fullname,
    COALESCE(score, 0) + 10 AS bonusscore
FROM customers;
```

Explanation
* `CONCAT()` - Combines first and last names
* `IFNULL(lastname, '')` → Handles missing last names
* `COALESCE(score, 0)` → Replaces NULL scores with 0
* `+ 10` → Adds bonus points

---

### QUESTION 3: Sort Customers by Score (NULLs Last)
Sort customers from lowest to highest score, ensuring NULL values appear last.

```sql
SELECT firstname, lastname, IFNULL(score, 999999) AS score
FROM customers
ORDER BY score;
```

Explanation 
* `IFNULL(score, 999999)` → Pushes NULL scores to the bottom
* Sorting is done in ascending order

---

### NULLIF Tasks
QUESTION 4: Calculate Sales Price per Order
Find the sales price by dividing sales by quantity, avoiding division errors.

```sql
SELECT orderid, sales / NULLIF(quantity, 0) AS sales_price
FROM orders;
```

Explanation
* `NULLIF(quantity, 0)` → Prevents division by zero
* Division by `NULL` safely returns `NULL`

---

### IS NULL & IS NOT NULL Tasks
QUESTION 5: Identify Customers with No Scores
```sql
SELECT customerid, score
FROM customers
WHERE score IS NULL;
```
✔️ Returns customers whose score is missing

---

QUESTION 6: List Customers with Scores
```sql
SELECT customerid, score
FROM customers
WHERE score IS NOT NULL;
```

✔️ Returns customers with available scores

---

### Join + NULL Filtering Task
QUESTION 7: Customers Who Have Not Placed Any Orders
List all details for customers who have never placed an order.

```sql
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customerid = o.customerid
WHERE o.customerid IS NULL;
```
---

### HOW THIS WORKS
1. `LEFT JOIN` → Returns all customers
2. `WHERE o.customerid IS NULL` → Filters customers without matching orders

✔️ Output: Customers who have never placed an order

---

### SUMMARY
This repository demonstrates how to:
* Handle missing data safely
* Prevent calculation errors
* Write clean and reliable SQL queries
* Use NULL functions in real business scenarios


