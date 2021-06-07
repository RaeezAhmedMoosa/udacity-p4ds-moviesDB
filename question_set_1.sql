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
