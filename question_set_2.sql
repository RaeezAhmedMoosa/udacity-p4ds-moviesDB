### movies-db Question Set 2 SQL

#### Question 1

/*
We want to find out how the two stores compare in their count of rental orders
during every month for all the years we have data for.

Write a query that returns the store ID for the store, the year and month and
the number of rental orders each store has fulfilled for that month. Your table
should include a column for each of the following:

• year
• month
• store ID
• count of rental orders fulfilled during that month.
*/

-- Exploratory DQLs
SELECT r.staff_id AS staff_id,
       DATE_TRUNC('year', r.rental_date) AS year,
       DATE_TRUNC('month', r.rental_date) AS month,
       COUNT(r.rental_id) AS rental_orders
FROM rental r
GROUP BY 1, 2, 3
ORDER BY 3;



SELECT s.store_id AS store_id,
       sub1.year AS year,
       sub1.month AS month,
       sub1.rental_orders AS rental_orders,
       SUM(sub1.rental_orders) OVER
       (PARTITION BY s.store_id ORDER BY sub1.year, sub1.month) AS running_total
FROM (
  SELECT r.staff_id AS staff_id,
         DATE_TRUNC('year', r.rental_date) AS year,
         DATE_TRUNC('month', r.rental_date) AS month,
         COUNT(r.rental_id) AS rental_orders
  FROM rental r
  GROUP BY 1, 2, 3
) sub1
LEFT JOIN store s
ON s.manager_staff_id = sub1.staff_id
ORDER BY 1, 2, 3;


-- Final Working DQL
SELECT s.store_id AS store_id,
       EXTRACT('year' FROM sub1.year) AS year,
       EXTRACT('month' FROM sub1.month) AS month,
       sub1.rental_orders AS rental_orders,
       SUM(sub1.rental_orders) OVER
       (PARTITION BY s.store_id ORDER BY sub1.year, sub1.month) AS running_total
FROM (
  SELECT r.staff_id AS staff_id,
         DATE_TRUNC('year', r.rental_date) AS year,
         DATE_TRUNC('month', r.rental_date) AS month,
         COUNT(r.rental_id) AS rental_orders
  FROM rental r
  GROUP BY 1, 2, 3
) sub1
LEFT JOIN store s
ON s.manager_staff_id = sub1.staff_id
ORDER BY 1, 2, 3;




#### Question 2

/*
We would like to know who were our top 10 paying customers, how many payments
they made on a monthly basis during 2007, and what was the amount of the monthly
payments.

Can you write a query to capture the customer name, month and year of payment,
and total payment amount for each month by these top 10 paying customers?
*/

-- Exploratory DQLs
SELECT DATE_TRUNC('month', p.payment_date) AS month,
       cu.first_name || ' ' || cu.last_name AS full_name,
       p.amount AS amount
FROM payment p
LEFT JOIN customer cu
ON cu.customer_id = p.customer_id
ORDER BY 1, 2;



SELECT DATE_TRUNC('month', p.payment_date) AS month,
       cu.first_name || ' ' || cu.last_name AS full_name,
       COUNT(p.payment_id) AS payment_count
FROM payment p
LEFT JOIN customer cu
ON cu.customer_id = p.customer_id
GROUP BY 1, 2
ORDER BY 2;
-- This DQL returns the number of orders per customer for each month


SELECT DATE_TRUNC('month', p.payment_date) AS month,
       cu.first_name || ' ' || cu.last_name AS full_name,
       SUM(p.amount) AS sum_amount
FROM payment p
LEFT JOIN customer cu
ON cu.customer_id = p.customer_id
GROUP BY 1, 2
ORDER BY 1, 2;
-- This DQL returns the total amount paid per customer for each month


-- Working final DQL for Q2 in QS
WITH t1 AS (
  SELECT DATE_TRUNC('month', p.payment_date) AS month,
         cu.first_name || ' ' || cu.last_name AS full_name,
         COUNT(p.payment_id) AS payment_count
  FROM payment p
  LEFT JOIN customer cu
  ON cu.customer_id = p.customer_id
  GROUP BY 1, 2
),
     t2 AS
(
  SELECT DATE_TRUNC('month', p.payment_date) AS month,
         cu.first_name || ' ' || cu.last_name AS full_name,
         SUM(p.amount) AS sum_amount
  FROM payment p
  LEFT JOIN customer cu
  ON cu.customer_id = p.customer_id
  GROUP BY 1, 2
)
SELECT t1.month,
       t1.full_name,
       t1.payment_count,
       t2.sum_amount
FROM t1
LEFT JOIN t2
ON t1.month = t2.month AND t1.full_name = t2.full_name
ORDER BY 4 DESC
LIMIT 10;



#### Question 3A

/*
In terms of percentage, how many movies are found within each category?

What is the overall Top 5 categories?
*/

-- Exploratory DQLs
SELECT c.name AS category,
	   f.title AS title
FROM category c
LEFT JOIN film_category fc
ON c.category_id = fc.category_id
LEFT JOIN film f
ON f.film_id = fc.film_id
ORDER BY 1;


-- Working Final DQL
SELECT sub1.category,
       COUNT(sub1.title) AS movie_count
FROM (
  SELECT c.name AS category,
	   f.title AS title
FROM category c
LEFT JOIN film_category fc
ON c.category_id = fc.category_id
LEFT JOIN film f
ON f.film_id = fc.film_id
) sub1
GROUP BY 1
ORDER BY 2 DESC;



#### Question 4A

/*
Which categories have an average rental rate greater than the overall average
rental rate? Please round off your final values to 2 decimal places.
*/

-- Exploratory DQLs
SELECT AVG(f.rental_rate) AS ovr_avg
FROM film f;


SELECT c.name AS category,
       f.title AS title,
       f.rental_rate AS rental_rate
FROM category c
LEFT JOIN film_category fc
ON c.category_id = fc.category_id
LEFT JOIN film f
ON f.film_id = fc.film_id
ORDER BY 1;


-- Final Working DQL for Q4A
SELECT sub1.category,
       ROUND(AVG(sub1.rental_rate), 2) AS avg_rental
FROM (
  SELECT c.name AS category,
         f.title AS title,
         f.rental_rate AS rental_rate
  FROM category c
  LEFT JOIN film_category fc
  ON c.category_id = fc.category_id
  LEFT JOIN film f
  ON f.film_id = fc.film_id
) sub1
GROUP BY 1
HAVING AVG(sub1.rental_rate) > (
  SELECT AVG(f.rental_rate) AS ovr_avg
  FROM film f
)
ORDER BY 2 DESC;
