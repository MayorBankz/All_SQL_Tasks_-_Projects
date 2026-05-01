# SQL Sales Analysis Project1 (MySQL)

## 📌 Project Overview

This project demonstrates how to use **MySQL** to analyze a relational sales database and answer common **business-driven questions** using SQL.

The analysis focuses on understanding **customer behavior, product performance, order activity, and revenue trends** by working with multiple related tables and applying joins, aggregations, filters, and date logic.

This project is designed to showcase **practical SQL skills** that are commonly required in data analyst and business intelligence roles.

---

## 🗂️ Dataset Description

The project uses the following tables:

### 1. brands

* `brand_id`
* `brand_name`

### 2. categories

* `category_id`
* `category_name`

### 3. customers

* `customer_id`
* `first_name`
* `last_name`
* `phone`
* `email`
* `street`
* `city`
* `state`
* `zip_code`

### 4. orders

* `order_id`
* `customer_id`
* `order_status`
* `order_date`
* `required_date`
* `shipped_date`
* `store_id`
* `staff_id`

### 5. order_items

* `order_id`
* `item_id`
* `product_id`
* `quantity`
* `list_price`
* `discount` (stored as decimal)

### 6. products

* `product_id`
* `product_name`
* `brand_id`
* `category_id`
* `model_year`
* `list_price`

### 7. staffs

* `staff_id`
* `first_name`
* `last_name`
* `email`
* `phone`
* `active`
* `store_id`
* `manager_id`

### 8. stocks

* `store_id`
* `product_id`
* `quantity`

### 9. stores

* `store_id`
* `store_name`
* `phone`
* `email`
* `street`
* `city`

---

## 🛠️ Tools & Technologies

* **MySQL**
* **SQL** (Joins, Aggregations, Subqueries, Date Functions)
* **GitHub** for version control and documentation

---

## 📊 Business Questions Answered

The following business questions were answered using SQL:

1. List all customers who have ordered a product that costs over $500
2. Get the names of customers who ordered products priced above $1000
3. Show the order date and quantity for each product ordered by each customer
4. Find customers who have placed more than 2 orders
5. Find the customer who has spent the most on a single order
6. Retrieve revenue generated from each state
7. List customers who placed orders in 2016 but not in 2018
8. Find brands that have sold more than 100 products in total
9. Retrieve orders made by customers who spent more than the average customer spending
10. List products with the highest order quantity in the last 6 months of 2017

---

## 🧠 Key Concepts Demonstrated

* INNER JOINs across multiple related tables
* Aggregate functions: `SUM`, `COUNT`, `MAX`, `AVG`
* Grouping and filtering with `GROUP BY` and `HAVING`
* Handling discounts stored as decimal values
* Date filtering and time-based analysis
* Business logic interpretation using SQL

---

## ▶️ How to Run the Project

1. Create the database and tables using the provided schema
2. Import the dataset into MySQL
3. Open any `.sql` file containing the queries
4. Execute queries using a MySQL client (MySQL Workbench, phpMyAdmin, CLI)

---

## 📝 Query Documentation Style

Each SQL query is documented using:

* The **business question** as a comment
* Clean formatting and meaningful table aliases
* Logical step-by-step joins
* Clear aggregation and filtering logic

Example:

```sql
-- Question: List customers who ordered products costing more than $500

SELECT DISTINCT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE p.list_price > 500;
```

---

## 🎯 Learning Outcomes

By completing this project, the following skills were strengthened:

* Translating business questions into SQL queries
* Working with normalized relational databases
* Writing readable, maintainable SQL
* Understanding sales and customer analytics

---

## 👤 Author

**Mayowa Idowu**

---

## ⭐ Notes

This project is intended for learning and portfolio demonstration purposes. It reflects real-world SQL use cases commonly encountered in retail and sales analytics.

---




