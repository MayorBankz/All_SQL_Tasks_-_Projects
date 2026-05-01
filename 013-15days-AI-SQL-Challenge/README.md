# 15-Days-SQL-Challenge
## Tool - MySQL & CHATGPT
## Date - 17-03-2026

---

### **OVERVIEW**

This repository contains my 15-day SQL challenge, where I solved progressively complex business problems using real-world scenarios.

The focus was on:

* Data Analysis
* Window functions
* Aggregations
* Joins
* Subqueries
* CTEs
* Business Logic implementation

---

**🎯 Challenge Goal**
To move from:
➡️ Basic SQL queries
➡️ To advanced analytical SQL used in real-world data roles

---

**🗂️ Dataset Overview**

Tables Used:
* `Orders` - Transactional data
* `Customers` - Customer details
* `Products` - product information

---

**📅 Challenge Breakdown
**
---

🚀 Day 1–2: Window Functions Mastery
🔷 Key Concepts
* `RANK()`, `DENSE_RANK()`
* `AVG() OVER()`
* `LAG()`
* Partitioning data

 ---

 **✅ Example: Top 3 Highest Sales Orders**

 ```sql
SELECT *
FROM (
    SELECT orderid,
           orderdate,
           sales,
           RANK() OVER (ORDER BY sales DESC) AS sales_rank
    FROM orders
) t
WHERE sales_rank <= 3;
```

---

**✅ Example: Sales vs Customer Average**
```sql
SELECT orderid,
       customerid,
       sales,
       AVG(sales) OVER (PARTITION BY customerid) AS avg_sales,
       CASE 
           WHEN sales > AVG(sales) OVER (PARTITION BY customerid) THEN 'Above Average'
           WHEN sales < AVG(sales) OVER (PARTITION BY customerid) THEN 'Below Average'
           ELSE 'Equal Average'
       END AS comparison
FROM orders;
```

---

**💡 Key Insight:**

Window function allow row_level + aggregated insights at the same time.

---
**📊 Day 3–5: Advanced Window Functions**
🔷 **Concepts**
* `LAG()` and `LEAD()`
* `FIRST_VALUE()` / `LAST_VALUE()`
* Running totals and averages
* Ranking with groups

---

**✅ Example: Sales Momentum**
```sql
SELECT customerid,
       orderid,
       sales,
       LAG(sales) OVER (PARTITION BY customerid ORDER BY orderdate) AS prev_sales,
       sales - LAG(sales) OVER (PARTITION BY customerid ORDER BY orderdate) AS sales_diff
FROM orders;
```

---

**✅ Example: Running Total per Customer**

```sql
SELECT customerid,
       orderid,
       orderdate,
       sales,
       SUM(sales) OVER (
           PARTITION BY customerid 
           ORDER BY orderdate
       ) AS running_total
FROM orders;
```

---

**💡 Key Insight:**
These queries simulate time-based analysis (very common in business dashboards).

---

**🔍 Day 6–7: Customer Behavior Analysis**

🔷 Concepts
* First & last transactions
* Customer trends
* Order gaps
* Lifetime value

---

**✅ Example: First Order Per Customer**

```sql
SELECT *
FROM (
    SELECT customerid,
           orderid,
           orderdate,
           ROW_NUMBER() OVER (
               PARTITION BY customerid 
               ORDER BY orderdate
           ) AS rn
    FROM orders
) t
WHERE rn = 1;
```

---

**✅ Example: Days Between Orders**
```sql
SELECT customerid,
       orderid,
       orderdate,
       DATEDIFF(
           orderdate,
           LAG(orderdate) OVER (
               PARTITION BY customerid 
               ORDER BY orderdate
           )
       ) AS days_between_orders
FROM orders;
```

---

**💡 Key Insight:**

This is how companies track:
* Customer retention
* Purchase frequency

---

**🔗 Day 8–9: Joins & Business Insights**

🔷 Concepts
* INNER JOIN
* LEFT JOJN
* Multi-table analysis

---

**✅ Example: Total Sales per Customer**

```sql
SELECT c.customerid,
       c.customername,
       SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c
ON o.customerid = c.customerid
GROUP BY c.customerid, c.customername;
```

---

**✅ Example: Products Never Ordered**

```
SELECT p.productid,
       p.productname
FROM products p
LEFT JOIN orders o
ON p.productid = o.productid
WHERE o.orderid IS NULL;
```

---

**💡 Key Insight:**
Joins help combine datasets to answer real business questions.
---

**📈 Day 10–11: Aggregation & Subqueries**
🔷 Concepts
* Nested queries
* Filtering aggregated results
* Business KPIs

---

**✅ Example: Above Average Customers**

```sql
SELECT customerid,
       SUM(sales) AS total_sales
FROM orders
GROUP BY customerid
HAVING SUM(sales) > (
    SELECT AVG(total_sales)
    FROM (
        SELECT customerid,
               SUM(sales) AS total_sales
        FROM orders
        GROUP BY customerid
    ) t
);
```

---

**💡 Key Insight:**
Subqueries allow multi-level analysis (very common in interviews).

---

**🧩 Day 12: CTEs (Common Table Expressions)**
🔷 Concepts
* Breaking complex queries into steps
* Reusable logic

---

**✅ Example: Customer Ranking**

```sql
WITH customer_total AS (
    SELECT customerid,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customerid
),
customer_rank AS (
    SELECT customerid,
           total_sales,
           RANK() OVER (ORDER BY total_sales DESC) AS rank
    FROM customer_total
)

SELECT *
FROM customer_rank;
```

---

**💡 Key Insight:**
CTEs make SQL clean, readable, and production-ready.
---

**📊 Day 13–14: Analytical SQL**
🔷 Concepts:
* Running totals
* Ranking
* Time-based filtering

---

**✅ Example: Running Total**

```sql
SELECT orderid,
       orderdate,
       sales,
       SUM(sales) OVER (ORDER BY orderdate) AS running_total
FROM orders;
```

---

**💡 Key Insight:**
These are used in
* Dashboards
* Reports
* KPI tracking

---

**🏁 Day 15: Business-Level SQL**

🔷 Concepts:
* Customer segmentation
* Advanced Filtering
* Real-world logic

---

**✅ Example: Customer Segmentation**
```sql
SELECT customerid,
       total_sales,
       CASE 
           WHEN total_sales > 100 THEN 'VIP'
           WHEN total_sales BETWEEN 60 AND 90 THEN 'Regular'
           ELSE 'Low Value'
       END AS customer_segment
FROM (
    SELECT customerid,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customerid
) t;
```

---

**📌 Final Takeaways**
✔ SQL is not just querying — it’s data analysis
✔ Window functions are game changers
✔ CTEs improve readability and structure
✔ Real-world SQL = combining multiple concepts

---

**🚀 What Was Achieved**
* Built strong SQL fundamentals
* Solved real-world business problems
* Mastered window functions
* Improved analytical thinking
