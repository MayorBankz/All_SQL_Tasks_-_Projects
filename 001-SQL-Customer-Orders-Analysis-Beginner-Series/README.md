# SQL_CUSTOMER_ORDERS_ANALYSIS
## Beginner-friendly MySQL practice queries demonstrating core SQL concepts such as GROUP BY, HAVING, ORDER BY, and LIMIT.
## TOOL - MySQL
## DATE - 28/01/2025

---

### 📘 SQL Practice: Customer & Orders Analysis

📌 Overview

This practice covers common SQL operations used to analyze customer and order data.
The focus is on sorting, aggregation, filtering, and limiting results using MySQL.

---

### 📂 TABLES USED
#### CUSTOMERS

| Column | Description |
| ------ | ----------- |
| id | Unique Customer Identifier |
| first_name | Customer's first name |
| country | Customer's country |
| Score | Customer's Score |

---

#### ORDERS 

| Column | Description |
| ------ | ----------- |
| Order_id | Unique order identifier |
| Order_date | Date the order was placed |

--- 

### 🧠 Practice Questions & Solutions

1. Retrieve all customers and sort results by country and highest score

```sql 
SELECT *
FROM customers
ORDER BY country, score DESC;
```

🔹 Sorts customers alphabetically by country, then by highest score within each country.

---

2. Find te total score for each country

```sql
select country, sum(score) as total_score
from customers
group by country
;
```
🔹 Calculates the combined score of customers per country.

---

3. Find the total score and total number of customers for each country

```sql
select country, sum(score) as total_score, count(id) as total_customers
from customers
group by country
;
```
🔹Shows both total score and customer count per country.

4. Find the average score for each country, considering only customers with a score not equal to 0, and return only those countries with an average score greater than 430

```sql
select country, avg(score) as avg_score
from customers 
where score != 0
group by country
having avg_score > 430
;
```
* `WHERE` - filters rows before aggregation
* `HAVING` - filters aggregated results
  
---

5. Return unique list of all countries

```sql
select distinct country
from customers
;
```
🔹Removes duplicates country values

---
6. Retrieve only top 3 customers

```sql
select *
from customers
order by score desc
limit 3;
```
🔹 Returns the customers with the highest scores.
* NOTE: LIMIT must be used with ORDER BY to correctly define "TOP"
---

7. Retrieve the Top 3 customers with the Highest Scores

```sql
select id, first_name, score
from customers
order by score desc
limit 3;
```
🔹Same as question 6, but selecting specific columns

---

8. Retrieve the lowest 2 customers based on the score

```sql
select id, first_name, score
from customers
order by score
limit 2;
```
🔹Order by score in ascending order to get the lowest values

---

9. Get the two most recent orders

```sql
select *
from orders
order by order_date desc;
```
🔹Fetches the latest orders using descending date order

---

### KEY SQL CONCEPTS PRACTICED
* `ORDER BY`
* `GROUP BY`
* `HAVING`
* `WHERE`
* `LIMIT`
* Aggregate functions (`SUM`, `COUNT`, `AVG`)
* `DISTINCT`
