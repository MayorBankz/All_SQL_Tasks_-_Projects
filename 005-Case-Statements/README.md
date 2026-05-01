# MySQL_Case_Statements_Practice
## Description: This repository contains structured SQL practice queries focused on mastering the CASE statement in MySQL.
## Date: 18-02-2026

---

## OVERVIEW 
The exercises demonstrate how to:
* Categorize data conditionally
* Transform column values
* Handle NULL values
* Perform conditional aggregation
* Improve report readability

---

Each task includes:
* The problem statement
* Step-by-step explanation
* Clean SQL solution
---

### CASE STATEMENT OVERVIEW
The `CASE` statement allows conditional logic inside SQL queries.
It works like an IF-ELSE statement:

```sql
CASE
  WHEN condition1 THEN result1
` WHEN condition2 THEN result2
  ELSE default_result
END
```
---

It can be used in:
* SELECT statements
* ORDER BY
* GROUP BY
* Aggregation functions (SUM, AVG, COUNT)

---

### Practice Questions & Solutions
✅ QUESTION 1: Categorize and Summarize Sales
🎯 Objective : Generate a report showing the total sales for each category:
- High: If the sales are higher than 50
- Medium: If the sales between 20 and 50
- Low: If the sales equal or lower than 20
- Sort result from lowest to highest

```sql
SELECT category, SUM(sales) AS total_sales
FROM (
    SELECT sales,
           CASE
               WHEN sales > 50 THEN 'High'
               WHEN sales BETWEEN 21 AND 50 THEN 'Medium'
               WHEN sales <= 20 THEN 'Low'
               ELSE 'N/A'
           END AS category
    FROM orders
) t
GROUP BY category
ORDER BY total_sales DESC;
```

📌 Explanation
1. The inner query categorizes each sales value
2. The CASE statement assigns labels
3. The result is treated as temporary table `t`
4. The outer query groups by category
5. `SUM(sales) calculates total sales per category
6. Results are sorted in descending order.

---
✅ QUESTION 2: Display Gender as Full Text
🎯 Objective: 
Convert abbreviated gender values:

'M' → Male

'F' → Female

Others/NULL → N/A

```sql
SELECT employeeid,
       firstname,
       lastname,
       gender,
       CASE
           WHEN gender = 'M' THEN 'Male'
           WHEN gender = 'F' THEN 'Female'
           ELSE 'N/A'
       END AS gender_full
FROM employees;
```

📌 Explanation: The CASE statement checks each gender value and replaces it with a readable format.

---

✅ QUESTION 3: Abbreviate Country Names
🎯 Objective:
Convert country names into abbreviations:

- Germany → DE

- USA → US

- Others → N/A

```sql
SELECT customerid,
       firstname,
       lastname,
       country,
       CASE
           WHEN country = 'Germany' THEN 'DE'
           WHEN country = 'USA' THEN 'US'
           ELSE 'N/A'
       END AS country_abbr
FROM customers;
```
📌 Explanation: CASE checks the country column and returns the corresponding abbreviation.

---

✅ QUESTION 4: Handle NULL Scores in Average Calculation 
🎯 Objective: 

- Calculate average customer scores:

- Replace NULL scores with 0

- Show customerid and lastname

- Calculate average per customer

```sql
SELECT customerid,
       lastname,
       AVG(
           CASE
               WHEN score IS NULL THEN 0
               ELSE score
           END
       ) AS avg_score
FROM customers
GROUP BY customerid, lastname;
```

---

📌 Explanation

1. CASE replaces NULL with 0.

2. AVG calculates the average of modified scores.

3. GROUP BY ensures average is per customer.

---

✅ Question 5: Conditional Counting Using CASE
🎯 Objective: Count how many times each customer made orders with sales greater than 30.

```sql
SELECT customerid,
       SUM(
           CASE
               WHEN sales > 30 THEN 1
               ELSE 0
           END
       ) AS total_orders
FROM orders
GROUP BY customerid;
```

---

📌 Explanation
1. If sales > 30 → return 1

2. Otherwise → return 0

3. SUM adds all 1s per customer

4. GROUP BY ensures count per customer

This technique is known as conditional aggregation.

---

### Key Concepts Learned
* Basic CASE Usage
* Nested CASE statements
* Combine CASE with COUNT()
* Practice with real-world datasets
