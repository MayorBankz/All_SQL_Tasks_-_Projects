# SQL_Aggregation_-_Window_Functions_Practice
## Date: 23-02-2026
## TOOL: MySQL
---

### OVERVIEW
This document contains basic Aggregation Functions and Window Function examples using the `orders` and `customers` tables.

---

### PART 1: Aggregation Functions
Aggregation functions summarize data and return a single result value.

---
### QUESTION 1: Find the Total Sales of All Orders

```sql
SELECT Sum(sales) as total_sales
FROM orders;
```
Explanation:
* `SUM(sales)` - Adds all sales values together
* Returns one row containing the total sales.

---

### QUESTION 2: Find the average sales of all orders
```sql
SELECT AVG(sales) as avg_sales
from orders;
```

Explanation 
* AVG(sales) - Calculates the average sales value.

---

### QUESTION 3: Find the total number of orders
```sql
SELECT COUNT(*) as total_ordes
FROM orders;
```

Explanation
* `COUNTS(*)` - Counts all rows in the table.

---

### QUESTION 4: Find the highest sales of all orders
```sql
SELECT MAX(sales) as max_sales
FROM Orders;
```

Explanation
* MAX(sales) - Returns the highest sales value
---

### QUESTION 5: Find the lowest score among customers
```sql
SELECT MIN(score) as min_score
FROM customers;
```

Explanation
* MIN(score) - Returns the smallest score value.

---

### PART 2: Aggregation with Window Functions

Window function perform calculations without collapsing rows.

---

✅ Question 1: Find the Total Sales Across All Orders
```sql
SELECT SUM(sales) AS total_sales
FROM orders;
```

✔ Normal aggregation — returns one row.

---

✅ Question 2: Find the Total Sales for Each Product (Without Collapsing Rows)
```sql
SELECT productid,
       SUM(sales) OVER (PARTITION BY productid) AS total_sales
FROM orders;
```

Explanation:

* OVER() → Converts SUM() into a window function.

* PARTITION BY productid → Groups calculation by product.

* Rows are NOT collapsed.

---

✅ Question 3: Total Sales per Product with Order Details

```sql
SELECT orderid,
       orderdate,
       productid,
       SUM(sales) OVER (PARTITION BY productid) AS total_sales
FROM orders;
```

Explanation: 
* Displays order details.

* Shows total sales per product beside each row.

---

✅ QUESTION 4: Total Sales Across All Orders with Order Details
```sql
SELECT orderid,
       orderdate,
       SUM(sales) OVER () AS total_sales
FROM orders;
```

Explanation:

* OVER() without PARTITION BY → Calculates total for entire table.

* Does not collapse rows.

---

✅ QUESTION 5: Total Sales per Product and Order Status
```sql
SELECT orderid,
       orderdate,
       productid,
       orderstatus,
       SUM(sales) OVER (PARTITION BY productid, orderstatus) AS total_sales
FROM orders;
```

Explanation:

* Groups logically by both productid and orderstatus.

* Calculates total sales for each unique combination.

---

✅ QUESTION 6: Rank Orders by Sales (Highest to Lowest)
```sql
SELECT orderid,
       orderdate,
       sales,
       RANK() OVER (ORDER BY sales DESC) AS sales_rank
FROM orders;
```



Explanation:

* RANK() → Assigns ranking number.

* DESC → Highest sales gets rank 1.

* Tied values share the same rank

---
✅ Question 7: Total Sales per Order Status (Only Products 101 & 102)

```sql
SELECT orderstatus,
       productid,
       sales,
       SUM(sales) OVER (PARTITION BY orderstatus) AS total_sales
FROM orders
WHERE productid IN (101,102);
```
Explanation:

* Filters to products 101 and 102.

* Calculates total sales per order status.

* Keeps individual rows.

---

✅ Question 8: Rank Customers Based on Their Total Sales

```sql
SELECT customerid,
       SUM(sales) AS total_sales,
       RANK() OVER (ORDER BY SUM(sales) DESC) AS customer_rank
FROM orders
GROUP BY customerid;
```

Explanation:

* `GROUP BY` customerid → Calculates total per customer.

* `RANK()` → Ranks customers from highest to lowest total sales.

* Ties share the same rank.

---

🎯 Key Concepts Summary

| Function | Purpose |
| -------- | ------- |
| `Sum()` | Adds values |
| `AVG()` | Calculates average |
| `COUNT()`  | Counts rows |
| `MAX()` | Highest value |
| `MIN()` | Lowest value |
| `OVER()` | Converts aggregates into window function |
| `PARTITION BY` | Divides data into logical groups |
| `RANK()` | Assigns ranking with gaps |

---

📌 Important Difference

| GROUP BY | WINDOW FUNCTION |
| -------- | --------------- |
| Collapses rows | Detailed result + summary |
| One row per group | All rows remain |
