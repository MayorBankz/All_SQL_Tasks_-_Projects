/* CASE STATEMENT TASKS 
QUESTION 1: Generate a report showing the total sales for each category:
- High: If the sales are higher than 50
- Medium: If the sales between 20 and 50
- Low: If the sales equal or lower than 20 
Sort the result from highest to lowest" 

STEP 1: The inner query (subquery) reads data from the "orders" table.

STEP 2: For each row, we check the value of "sales" using a CASE statement.

STEP 3: The CASE statement categorizes each sales value:
        - If sales > 50      → Label as 'High'
        - If sales 21–50     → Label as 'Medium'
        - If sales ≤ 20      → Label as 'Low'
        - Otherwise          → Label as 'N/A'

STEP 4: The result of the CASE statement is given the alias "category".

STEP 5: The subquery returns two columns:
        - sales
        - category
        This result is treated as a temporary table named "t".

STEP 6: The outer query works on this temporary table (t).

STEP 7: We group the rows by "category" using GROUP BY.
        This combines all rows that belong to the same category.

STEP 8: We calculate the total sales for each category using SUM(sales).

STEP 9: We sort the final result in descending order
        so the category with the highest total sales appears first.*/

select category, sum(sales) as total_sales
from (select sales,
case 	
	when sales > 50 then 'High'
    when sales between 21 and 50 then 'Medium'
    when sales <= 20 then 'Low'
else 'N/A'
end category
from orders
) t
group by category
order by total_sales desc
;

/* Question 2: Retrieve employee details with gender displayed as full text
STEP 1: Select employee basic details (employeeid, firstname, lastname, gender).

STEP 2: Use a CASE statement to check the value of the gender column.

STEP 3: If gender = 'M', display 'Male'.

STEP 4: If gender = 'F', display 'Female'.

STEP 5: If gender is NULL or any other value, display 'N/A'.

STEP 6: Assign the result of the CASE statement the alias "gender_full". */

select employeeid, firstname, lastname, gender,
case 
	when gender = 'M' then 'Male'
    when gender = 'F' then 'Female'
    else 'N/A'
End gender_full
From employees
;

/* Question 3: Retrieve customer details with abbreviated country code
STEP 1: Select customer basic details (customerid, firstname, lastname, country).

STEP 2: Use a CASE statement to check the value of the country column.

STEP 3: If country = 'Germany', return 'DE'.

STEP 4: If country = 'USA', return 'US'.

STEP 5: If the country does not match the listed values, return 'N/A'.

STEP 6: Assign the result of the CASE statement the alias "country_abbr" */
select customerid, firstname, lastname, country,
case 	
	when country = 'Germany' then 'DE'
    when country = 'USA' then 'US'
    else 'N/A'
end country_abbr
from customers
;

/* Question 4: Find the average scores of customers and treat NULLs as 0 and additionally provide details such as CustomerID and Lastname 
STEP 1: Select customerid and lastname to show customer details.

STEP 2: Use a CASE statement to check the score column.

STEP 3: If score IS NULL, replace it with 0.

STEP 4: If score is not NULL, keep the original score.

STEP 5: Use AVG() to calculate the average of the modified scores.

STEP 6: Use GROUP BY customerid and lastname
        to calculate the average score per customer.*/


select customerid, lastname, avg(
case 
	when score is null then 0
    when score is not null then score
end) as avg_score
from customers
group by customerid, lastname
;

/* QUESTION 5: Count how many times each customer has made an order with sales greater than 30
STEP 1: Select customerid to show each customer.

STEP 2: Use SUM with a CASE statement to count orders conditionally:
        - If sales > 30, return 1 (this order counts)
        - Otherwise, return 0 (does not count)

STEP 3: SUM adds up all the 1s for each customer, giving total orders above 30.

STEP 4: GROUP BY customerid to calculate the total per customer.

STEP 5: The result shows each customer and how many orders they made with sales greater than 30. */

select customerid, 
sum(
case
	when sales > 30 then 1
    else 0
end) total_orders
from orders
group by customerid
;
