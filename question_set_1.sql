### movies-db Question Set 1 SQL

#### Question 1

/*
We want to understand more about the movies that families are watching. The
following categories are considered family movies:

• Animation
• Children
• Classics
• Comedy
• Family
• Music.

Create a query that lists each movie, the film category it is classified in, and
the number of times it has been rented out.
*/

-- Exploratory SQL

/*
This DQL returns a list of film titles and their corresponding category. Both
'titles' and 'categories' values are stored in their own table. Therefore tables
have to be JOINed together in order to return this type of final table.
*/
SELECT f.title AS title,
       c.name AS category_name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON c.category_id = fc.category_id
ORDER BY 2;
-- 1000 rows

-- Exploratory SQL

/*
This DQL filters the 'category.name' column to only return rows that are linked
with the "Family" genre
*/
SELECT f.title AS title,
       c.name AS category_name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON c.category_id = fc.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 2;
-- 361 rows


-- Exploratory SQL
SELECT i.inventory_id AS inv_id,
       f.title AS title,
       i.store_id AS st_id
FROM inventory i
LEFT JOIN film f
ON f.film_id = i.film_id;


-- Exploratory SQL
SELECT i.inventory_id AS inv_id,
       sub1.title AS title,
       sub1.category_name AS category_name,
       i.store_id AS store_id
FROM (
  SELECT f.film_id AS film_id,
         f.title AS title,
         c.name AS category_name
  FROM film f
  LEFT JOIN film_category fc
  ON f.film_id = fc.film_id
  LEFT JOIN category c
  ON c.category_id = fc.category_id
  WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
) sub1
LEFT JOIN inventory i
ON sub1.film_id = i.film_id
ORDER BY 3;


-- Exploratory DQL
WITH t1 AS
(
  SELECT i.inventory_id AS inv_id,
         sub1.title AS title,
         sub1.category_name AS category_name,
         i.store_id AS store_id
  FROM (
    SELECT f.film_id AS film_id,
           f.title AS title,
           c.name AS category_name
    FROM film f
    LEFT JOIN film_category fc
    ON f.film_id = fc.film_id
    LEFT JOIN category c
    ON c.category_id = fc.category_id
    WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
  ) sub1
  LEFT JOIN inventory i
  ON sub1.film_id = i.film_id
  ORDER BY 3
)
SELECT t1.title AS title,
       t1.category_name AS category_name,
       r.rental_id AS r_id
FROM t1
LEFT JOIN rental r
ON t1.inv_id = r.inventory_id
ORDER BY 2, 1;


-- Working version of Final DQL
WITH t1 AS
(
  SELECT i.inventory_id AS inv_id,
         sub1.title AS title,
         sub1.category_name AS category_name,
         i.store_id AS store_id
  FROM (
    SELECT f.film_id AS film_id,
           f.title AS title,
           c.name AS category_name
    FROM film f
    LEFT JOIN film_category fc
    ON f.film_id = fc.film_id
    LEFT JOIN category c
    ON c.category_id = fc.category_id
    WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
  ) sub1
  LEFT JOIN inventory i
  ON sub1.film_id = i.film_id
  ORDER BY 3
)
SELECT t1.title AS title,
       t1.category_name AS category_name,
       COUNT(r.rental_id) AS rental_count
FROM t1
LEFT JOIN rental r
ON t1.inv_id = r.inventory_id
GROUP BY 1, 2
ORDER BY 2, 1;



-- Working Final DQL
SELECT sub1.title AS title,
       sub1.category_name AS category_name,
       COUNT(r.rental_id) AS rental_count
FROM (
  SELECT f.film_id AS film_id,
         f.title AS title,
         c.name AS category_name
  FROM film f
  LEFT JOIN film_category fc
  ON f.film_id = fc.film_id
  LEFT JOIN category c
  ON c.category_id = fc.category_id
  WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
) sub1
LEFT JOIN inventory i
ON sub1.film_id = i.film_id
LEFT JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY 1, 2
ORDER BY 2, 3 DESC;


-- Working DQL with Window Function to verify total SUMs
WITH t1 AS
(
  SELECT sub1.title AS title,
         sub1.category_name AS category_name,
         COUNT(r.rental_id) AS rental_count
  FROM (
    SELECT f.film_id AS film_id,
           f.title AS title,
           c.name AS category_name
    FROM film f
    LEFT JOIN film_category fc
    ON f.film_id = fc.film_id
    LEFT JOIN category c
    ON c.category_id = fc.category_id
    WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
  ) sub1
  LEFT JOIN inventory i
  ON sub1.film_id = i.film_id
  LEFT JOIN rental r
  ON r.inventory_id = i.inventory_id
  GROUP BY 1, 2
)
SELECT t1.title AS title,
       t1.category_name AS category,
       t1.rental_count,
       SUM(t1.rental_count) OVER
       (PARTITION BY t1.category_name ORDER BY t1.rental_count) AS rental_sum
FROM t1;



/*
This is the final DQL that will be used for Question 1. This DQL returns a list
of categories within the Family genre and the total amount of times each category
was rented.

This DQL will be used as the foundation to create a visual (bar chart) to show
which category was the most popular amongst families.
*/
WITH t1 AS
(
  SELECT sub1.title AS title,
         sub1.category_name AS category_name,
         COUNT(r.rental_id) AS rental_count
  FROM (
    SELECT f.film_id AS film_id,
           f.title AS title,
           c.name AS category_name
    FROM film f
    LEFT JOIN film_category fc
    ON f.film_id = fc.film_id
    LEFT JOIN category c
    ON c.category_id = fc.category_id
    WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
  ) sub1
  LEFT JOIN inventory i
  ON sub1.film_id = i.film_id
  LEFT JOIN rental r
  ON r.inventory_id = i.inventory_id
  GROUP BY 1, 2
)
SELECT t1.category_name AS category,
       SUM(t1.rental_count) AS rental_sum
FROM t1
GROUP BY 1
ORDER BY 2 DESC;
-- This DQL is used to create the visualisation in excel for Question 1


/*
Question 1A

What are the Top 10 movies for the category with the most total rentals within
the family genre and how many times was each movie rented in total?
*/

-- Working final DQL
SELECT sub1.title AS title,
       sub1.category_name AS category_name,
       COUNT(r.rental_id) AS rental_count
FROM (
  SELECT f.film_id AS film_id,
         f.title AS title,
         c.name AS category_name
  FROM film f
  LEFT JOIN film_category fc
  ON f.film_id = fc.film_id
  LEFT JOIN category c
  ON c.category_id = fc.category_id
  WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
) sub1
LEFT JOIN inventory i
ON sub1.film_id = i.film_id
LEFT JOIN rental r
ON r.inventory_id = i.inventory_id
WHERE sub1.category_name = 'Animation'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
-- This DQL is used for the visualisation in excel for Question 1A




#### Question 2

/*
Now we need to know how the length of rental duration of these family-friendly
movies compares to the duration that all movies are rented for.

Can you provide a table with the movie titles and divide them into 4 levels
(first_quarter, second_quarter, third_quarter, and final_quarter) based on the
quartiles (25%, 50%, 75%) of the rental duration for movies across all
categories?

Make sure to also indicate the category that these family-friendly movies fall
into.
*/

-- Exploratory DQL
SELECT f.title AS title,
       f.rental_duration AS duration
FROM film f
ORDER BY 2 DESC;


-- Exploratory DQL
SELECT f.title AS title,
       c.name AS category,
       f.rental_duration AS duration
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON c.category_id = fc.category_id
ORDER BY 2;


-- Exploratory DQL
SELECT f.title AS title,
       c.name AS category,
       f.rental_duration AS duration,
       NTILE(4) OVER
       (ORDER BY f.rental_duration) AS quartile
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON c.category_id = fc.category_id
ORDER BY 2, 4;


-- Exploratory DQL
SELECT sub1.title AS title,
       sub1.category AS category,
       sub1.duration AS duration,
       sub1.quartile AS quartile,
  CASE WHEN sub1.quartile = 1 THEN '1st_quartile'
       WHEN sub1.quartile = 2 THEN '2nd_quartile'
       WHEN sub1.quartile = 3 THEN '3rd_quartile'
       ELSE '4th_quartile' END AS quartile_type
FROM (
  SELECT f.title AS title,
         c.name AS category,
         f.rental_duration AS duration,
         NTILE(4) OVER
         (ORDER BY f.rental_duration) AS quartile
  FROM film f
  LEFT JOIN film_category fc
  ON f.film_id = fc.film_id
  LEFT JOIN category c
  ON c.category_id = fc.category_id
) sub1
WHERE sub1.category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 4;


-- Working final DQL for Question 2 in Question Set 1
WITH t1 AS
(
  SELECT sub1.title AS title,
         sub1.category AS category,
         sub1.duration AS duration,
         sub1.quartile AS quartile,
    CASE WHEN sub1.quartile = 1 THEN '1st_quartile'
         WHEN sub1.quartile = 2 THEN '2nd_quartile'
         WHEN sub1.quartile = 3 THEN '3rd_quartile'
         ELSE '4th_quartile' END AS quartile_type
  FROM (
    SELECT f.title AS title,
           c.name AS category,
           f.rental_duration AS duration,
           NTILE(4) OVER
           (ORDER BY f.rental_duration) AS quartile
    FROM film f
    LEFT JOIN film_category fc
    ON f.film_id = fc.film_id
    LEFT JOIN category c
    ON c.category_id = fc.category_id
  ) sub1
  WHERE sub1.category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
)
SELECT t1.category,
       t1.quartile_type,
       COUNT(t1.quartile_type) AS quartile_count
FROM t1
GROUP BY 1, 2
ORDER BY 1, 2;
