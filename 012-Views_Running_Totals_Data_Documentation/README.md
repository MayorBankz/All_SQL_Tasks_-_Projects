# SQL-Views-Practice-Running-totals-Data-Combination
## Tool - MySQL
## Date - 17-03-2026
---

## **OVERVIEW**

This project demonstrates how to use SQL views for:
* Running totals using window functions
* Combining multiple tables
* Managing views (create, drop, update)

---

📁 **Overview of Tasks**
✅ Question 1: 
Find the running total of sales for each month
✅ Question 2:
Create a view that combines:
* Orders
* Products
* Customers
* Employees

---

**🚀 Task 1: Running Total per Month**
📌 Objective
Calculate a running total of sales within each month.

---

**⚠️ Important Fix**
❌ Original issue:
* Unnecessary parentheses in `CREATE VIEW`

---

```sql
CREATE VIEW salesdb.running_total_per_month AS
SELECT 
    YEAR(orderdate) AS year,
    MONTH(orderdate) AS month,
    orderdate,
    sales,
    SUM(sales) OVER (
        PARTITION BY YEAR(orderdate), MONTH(orderdate)
        ORDER BY orderdate
    ) AS running_total
FROM orders;
```

---

🧠 Explanation
* `PARTITION BY YEAR, MONTH` - resets total every month
* `ORDER BY orderdate` - ensures proper accumulation
* `SUM() OVER()` - Calculates running total

---

📊 Example Output

| Date  | Sales | Running Total |
| ----- | ----- | ------------- |
| Jan 1 | 10    | 10            |
| Jan 2 | 20    | 30            |

---

**🔗 Task 2: Combined Sales Details View**
📌 Objective
Create a single view that combines multiple tables for analysis.

```sql
CREATE VIEW sales_details AS
SELECT 
    c.customerid,
    e.employeeid,
    o.orderid,
    p.product,
    p.price,
    o.quantity,
    o.sales
FROM products AS p
LEFT JOIN orders AS o
    ON p.productid = o.productid
LEFT JOIN customers AS c
    ON c.customerid = o.customerid
LEFT JOIN employees AS e
    ON e.employeeid = o.salespersonid;
```

---

🧠 Explanation

* `LEFT JOIN` ensures all products are included
* Combines:
    * Customer info
    * Employee info
    * Product details
    * Order data
---

### **💡 Use Case**
* Business reporting
* Dashboards (PowerBI, Tableau)
* Sales analysis

---

### **🗑️ Dropping a View**
📌 Syntax
```sql
DROP VIEW running_total_per_month;
```
---

### **🛡️ Safer Option**
```sql
DROP VIEW IF EXISTS running_total_per_month;
```

---

### **🔄 Updating a View**
📌 Scenario
You created a view:

```sql
CREATE VIEW customers_total AS 
SELECT 
    customerid,
    SUM(sales) AS total_sales
FROM orders
GROUP BY customerid;
```
---

❌ Limitation

SQL version does not support
```sql
CREATE OR REPLACE VIEW
```

---

### **✅ Correct Approach**

Step 1: Drop the View
```sql
DROP VIEW customers_total;
```
Step 2: Recreate with Updated Logic

```
CREATE VIEW customers_total AS 
SELECT 
    customerid,
    SUM(sales) AS total_sales,
    COUNT(orderid) AS total_orders
FROM orders
GROUP BY customerid;
```

---

### **⚠️ Important Notes**
* Views Do Not Store Data
* They execute the query everytime

---

🔸 Be Careful When Updating
* Dropping a view may affect dependent queries
* Permissions may reset

---

🔸 Naming Best Practices
* `Running_total_per_month`
* `Sales_details`
Good ✅:
Bad ❌:
`view1`

---

### **🧠 Key Takeaways**

* Views simplify complex queries
* Window functions are powerful for analytics
* Always include YEAR when grouping by MONTH
* Use 'LEFT JOJN' for full data visibility
* Update views carefully in production

---

### **🏁 Conclusion**
This project demonstrates how to
* Use views for analytical queries
* Combine multiple tables into a single source
* Manage and update views effectively
