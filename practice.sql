### movies-db Practice SQL

#### Practice Quiz 1

/*
Let's start with creating a table that provides the following details: actor's
first and last name combined as full_name, film title, film description and
length of the movie.

How many rows are there in the table?

*/

-- actor db
SELECT *
FROM actor
LIMIT 10;

SELECT COUNT(*) AS row_count
FROM actor;
-- 200 rows


SELECT a.first_name || ' ' || a.last_name AS full_name
FROM actor a;


-- film db
SELECT COUNT(*) AS row_count
FROM film;
-- 1000 rows


SELECT *
FROM film
LIMIT 10;


-- film_actor db
SELECT COUNT(*) AS row_count
FROM film_actor;
-- 5462 rows


SELECT *
FROM film_actor
LIMIT 10;


-- Question 1
SELECT a.first_name || ' ' || a.last_name AS full_name,
       f.title AS title,
       f.description AS description,
       f.length AS length
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON f.film_id = fa.film_id;


SELECT COUNT(sub1.*) AS row_count
FROM (
  SELECT a.first_name || ' ' || a.last_name AS full_name,
         f.title AS title,
         f.description AS description,
         f.length AS length
  FROM actor a
  LEFT JOIN film_actor fa
  ON a.actor_id = fa.actor_id
  LEFT JOIN film f
  ON f.film_id = fa.film_id
) sub1;
-- 5462 rows



/*
Write a query that creates a list of actors and movies where the movie length
was more than 60 minutes. How many rows are there in this query result?
*/
WITH t1 AS (
  SELECT a.first_name || ' ' || a.last_name AS full_name,
         f.title AS title,
         f.description AS description,
         f.length AS length
  FROM actor a
  LEFT JOIN film_actor fa
  ON a.actor_id = fa.actor_id
  LEFT JOIN film f
  ON f.film_id = fa.film_id
)
SELECT COUNT(t1.*) AS row_count
FROM t1
WHERE t1.length > 60;
-- 4900 rows



/*
Write a query that captures the actor id, full name of the actor, and counts the
number of movies each actor has made. (HINT: Think about whether you should
group by actor id or the full name of the actor.) Identify the actor who has
made the maximum number movies.
*/


-- actor db
SELECT a.actor_id AS id,
       a.first_name || ' ' || a.last_name AS full_name
FROM actor a;


-- JOIN
SELECT sub1.id AS id,
       sub1.full_name AS full_name,
       f.title AS title
FROM (
  SELECT a.actor_id AS id,
         a.first_name || ' ' || a.last_name AS full_name
  FROM actor a
) sub1
LEFT JOIN film_actor fa
ON sub1.id = fa.actor_id
LEFT JOIN film f
ON f.film_id = fa.film_id;


-- film count by actor
WITH t1 AS
(
  SELECT sub1.id AS id,
         sub1.full_name AS full_name,
         f.title AS title
  FROM (
    SELECT a.actor_id AS id,
           a.first_name || ' ' || a.last_name AS full_name
    FROM actor a
  ) sub1
  LEFT JOIN film_actor fa
  ON sub1.id = fa.actor_id
  LEFT JOIN film f
  ON f.film_id = fa.film_id
)
SELECT t1.id,
       t1.full_name,
       COUNT(t1.title) AS film_count
FROM t1
GROUP BY 1, 2
ORDER BY 3 DESC;
-- Gina Degeneres with 42 films



#### Practice Quiz 2

/*
Question 1

Write a query that displays a table with 4 columns: actor's full name, film
title, length of movie, and a column name "filmlen_groups" that classifies
movies based on their length. Filmlen_groups should include 4 categories:

• 1 hour or less
• Between 1-2 hours
• Between 2-3 hours
• More than 3 hours

*/

-- JOINed table
SELECT a.first_name || ' ' || a.last_name AS full_name,
       f.title AS title,
       f.length AS length
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON f.film_id = fa.film_id;


-- Final DQL
SELECT DISTINCT sub1.title,
       sub1.length,
  CASE WHEN sub1.length <= 60 THEN '1 hour or less'
       WHEN sub1.length > 60 AND sub1.length <= 120 THEN 'between 1 - 2 hours'
       WHEN sub1.length > 120 AND sub1.length <= 180 THEN 'between 2 - 3 hours'
       ELSE 'more than 3 hours' END AS filmlen_group
FROM (
  SELECT a.first_name || ' ' || a.last_name AS full_name,
         f.title AS title,
         f.length AS length
  FROM actor a
  LEFT JOIN film_actor fa
  ON a.actor_id = fa.actor_id
  LEFT JOIN film f
  ON f.film_id = fa.film_id
) sub1;



/*
Question 2

Now, we bring in the advanced SQL query concepts! Revise the query you wrote
above to create a count of movies in each of the 4 filmlen_groups:

• 1 hour or less
• Between 1-2 hours
• Between 2-3 hours
• More than 3 hours
*/

-- Final DQL
WITH t1 AS (
  SELECT DISTINCT sub1.title,
         sub1.length,
    CASE WHEN sub1.length <= 60 THEN '1 hour or less'
         WHEN sub1.length > 60 AND sub1.length < 120 THEN 'between 1 - 2 hours'
         WHEN sub1.length > 120 AND sub1.length < 180 THEN 'between 2 - 3 hours'
         ELSE 'more than 3 hours' END AS filmlen_group
  FROM (
    SELECT a.first_name || ' ' || a.last_name AS full_name,
           f.title AS title,
           f.length AS length
    FROM actor a
    LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
    LEFT JOIN film f
    ON f.film_id = fa.film_id
  ) sub1
)
SELECT t1.filmlen_group,
       COUNT(t1.*) AS film_count
FROM t1
GROUP BY 1
ORDER BY 2 DESC;


-- Udacity SQL solution
SELECT    DISTINCT(filmlen_groups),
          COUNT(title) OVER (PARTITION BY filmlen_groups) AS filmcount_bylencat
FROM
         (SELECT title,length,
          CASE WHEN length <= 60 THEN '1 hour or less'
          WHEN length > 60 AND length <= 120 THEN 'Between 1-2 hours'
          WHEN length > 120 AND length <= 180 THEN 'Between 2-3 hours'
          ELSE 'More than 3 hours' END AS filmlen_groups
          FROM film ) t1
ORDER BY  filmlen_groups
