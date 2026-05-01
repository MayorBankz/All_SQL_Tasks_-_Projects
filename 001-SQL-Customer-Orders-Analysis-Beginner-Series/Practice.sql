-- Question 1: Retrieve all customers and sort the results by country and then by the highest score.

select *
from customers
order by country, score desc;

-- Question 2: Find te total score for each country

select country, sum(score) as total_score
from customers
group by country
;

-- Question 3: Find the total score and total number of customers for each country

select country, sum(score) as total_score, count(id) as total_customers
from customers
group by country
;

-- Question 4: Find the average score for each country, considering only customers with a score not equal to 0, and return only those countries with an average score greater than 430

select country, avg(score) as avg_score
from customers 
where score != 0
group by country
having avg_score > 430
;

-- Question 5: Return unique list of all countries

select distinct country
from customers
;

-- Question 6: Retrieve only top 3 customers

select *
from customers
order by score desc
limit 3;

-- Question 7: Retrieve the Top 3 customers with the Highest Scores

select id, first_name, score
from customers
order by score desc
limit 3;

-- Question 8: Retrieve the lowest 2 customers based on the score

select id, first_name, score
from customers
order by score
limit 2;

-- Question 9: Get the two most recent orders

select *
from orders
order by order_date desc
limit 2;
