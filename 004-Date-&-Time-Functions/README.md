# 📅 MySQL Date and Time Functions
## Date: 01-05-2026 (Had to recreate, mistakenly deleted repo on github)

A complete and practical guide to working with **date and time in MySQL**.

---

## 📌 Table of Contents

* Introduction
* Getting Current Date & Time
* Extracting Date Parts
* Formatting Dates
* Date Calculations
* Date Differences
* Conversion Functions
* Common Use Cases
* Best Practices

---

# 🧠 Introduction

MySQL provides powerful functions to:

* Get current date/time
* Extract specific parts (year, month, etc.)
* Format date output
* Perform date calculations

---

# ⏰ 1. Get Current Date & Time

```sql
SELECT NOW();        -- Current date & time
SELECT CURDATE();    -- Current date only
SELECT CURTIME();    -- Current time only
```

---

# 🔍 2. Extract Parts of a Date

```sql
SELECT 
    YEAR(NOW())   AS year,
    MONTH(NOW())  AS month,
    DAY(NOW())    AS day,
    HOUR(NOW())   AS hour,
    MINUTE(NOW()) AS minute,
    SECOND(NOW()) AS second;
```

---

# 🎨 3. Format Dates

```sql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS formatted_date;
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y') AS formatted_date;
SELECT DATE_FORMAT(NOW(), '%W, %M %d %Y') AS full_format;
```

### Common Format Specifiers

| Format | Meaning       |
| ------ | ------------- |
| %Y     | Year (2026)   |
| %m     | Month (01–12) |
| %d     | Day (01–31)   |
| %H     | Hour (00–23)  |
| %i     | Minutes       |
| %s     | Seconds       |
| %W     | Weekday name  |
| %M     | Month name    |

---

# ➕ 4. Add / Subtract Dates

```sql
-- Add
SELECT DATE_ADD(NOW(), INTERVAL 5 DAY);
SELECT DATE_ADD(NOW(), INTERVAL 2 MONTH);

-- Subtract
SELECT DATE_SUB(NOW(), INTERVAL 10 DAY);
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);
```

---

# 📊 5. Date Difference

```sql
SELECT DATEDIFF('2026-05-01', '2026-04-01') AS days_diff;

-- More precise difference
SELECT TIMESTAMPDIFF(MONTH, '2025-01-01', NOW()) AS months_diff;
SELECT TIMESTAMPDIFF(YEAR, '2000-01-01', NOW()) AS years_diff;
```

---

# 🔄 6. Convert Data Types

```sql
SELECT CAST(NOW() AS DATE);        -- Remove time
SELECT CAST(NOW() AS DATETIME);    -- Ensure datetime type
```

---

# 📆 7. First and Last Day of Month

```sql
-- First day of current month
SELECT DATE_SUB(CURDATE(), INTERVAL DAY(CURDATE()) - 1 DAY);

-- Last day of current month
SELECT LAST_DAY(CURDATE());
```

---

# 📅 8. Week, Quarter & Day Info

```sql
SELECT 
    WEEK(NOW()) AS week_number,
    QUARTER(NOW()) AS quarter,
    DAYNAME(NOW()) AS day_name,
    MONTHNAME(NOW()) AS month_name;
```

---

# ⚙️ Common Use Cases

---

## ✅ 1. Calculate Age

```sql
SELECT TIMESTAMPDIFF(YEAR, '1998-05-01', CURDATE()) AS age;
```

---

## ✅ 2. Filter Records by Date

```sql
SELECT *
FROM orders
WHERE order_date >= '2025-01-01';
```

---

## ✅ 3. Group by Month

```sql
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

---

## ✅ 4. Last 7 Days Records

```sql
SELECT *
FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);
```

---

## ✅ 5. Find Today's Records

```sql
SELECT *
FROM orders
WHERE DATE(order_date) = CURDATE();
```

---

# ⚠️ Best Practices

* ✅ Store dates using `DATE`, `DATETIME`, or `TIMESTAMP` (NOT strings)
* ✅ Use `TIMESTAMP` for automatic timezone handling
* ✅ Always index date columns for performance
* ❌ Avoid wrapping indexed columns in functions in `WHERE` clause:

  ❌ Bad:

  ```sql
  WHERE DATE(order_date) = CURDATE();
  ```

  ✅ Good:

  ```sql
  WHERE order_date >= CURDATE()
    AND order_date < CURDATE() + INTERVAL 1 DAY;
  ```

---

# 🚀 Quick Summary

| Task             | Function                         |
| ---------------- | -------------------------------- |
| Current DateTime | `NOW()`                          |
| Current Date     | `CURDATE()`                      |
| Format Date      | `DATE_FORMAT()`                  |
| Add Days         | `DATE_ADD()`                     |
| Subtract Days    | `DATE_SUB()`                     |
| Difference       | `DATEDIFF()` / `TIMESTAMPDIFF()` |

---

# 💡 Final Note

Mastering date functions is **critical for analytics**, especially for:

* Cohort analysis
* Time-series data
* Reporting dashboards

---

⭐ If this helped you, consider starring your repo once you recreate it!
