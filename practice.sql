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
