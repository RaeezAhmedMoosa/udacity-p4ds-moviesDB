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
