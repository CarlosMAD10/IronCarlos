USE sakila;

-- 1. How many copies of the film "Hunchback Impossible" exist in the inventory system?
SELECT title, COUNT(inventory_id) AS number_copies
FROM (SELECT film.title, inventory.inventory_id FROM inventory
INNER JOIN film ON film.film_id=inventory.film_id
WHERE film.title="Hunchback Impossible") AS derived_table;

-- 2. List all films whose length is longer than the average of all the films.
SELECT title FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name FROM actor 
WHERE actor_id IN (SELECT actor_id AS alone_actor_id FROM film_actor
WHERE film_actor.film_id = (SELECT film_id as alone_trip_id FROM film WHERE film.title = "Alone Trip"));

/* 4. Sales have been lagging among young families, and you wish to target all family movies for a 
promotion. Identify all movies categorized as family films. */
SELECT title FROM film WHERE film_id IN
(SELECT film_id FROM film_category WHERE category_id = 
(SELECT category_id 
FROM category WHERE `name`="family"));

/* 5.-Get name and email from customers from Canada using subqueries. Do the same with joins. 
Note that to create a join, you will have to identify the correct tables with their primary 
keys and foreign keys, that will help you get the relevant information. */
SELECT first_name, last_name, email 
FROM customer WHERE address_id IN
(SELECT address_id FROM address WHERE city_id IN
(SELECT city_id FROM city WHERE country_id = 
(SELECT country_id FROM country WHERE country="Canada")));

SELECT customer.first_name, customer.last_name, customer.email
FROM customer INNER JOIN address ON address.address_id=customer.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON country.country_id=city.country_id
WHERE country.country="Canada";

/* 6. Which are films starred by the most prolific actor? Most prolific actor is defined as 
the actor that has acted in the most number of films. First you will have to find the most 
prolific actor and then use that actor_id to find the different films that he/she starred. */
SELECT title FROM film WHERE film_id IN
(SELECT film_id FROM film_actor WHERE actor_id =
(SELECT actor_id FROM film_actor 
GROUP BY actor_id
ORDER BY COUNT(actor_id) DESC
LIMIT 1));
-- The actor that has starred in more movies, as we found out in the lab yesterday, is:
SELECT first_name, last_name FROM actor WHERE actor_id = (SELECT actor_id FROM film_actor 
GROUP BY actor_id
ORDER BY COUNT(actor_id) DESC
LIMIT 1);

/* 7. Films rented by most profitable customer. You can use the customer table 
and payment table to find the most profitable customer ie the customer that has
 made the largest sum of payments */
 SELECT title FROM film WHERE film_id IN 
 (SELECT film_id FROM inventory WHERE inventory_id IN 
 (SELECT inventory_id FROM rental WHERE customer_id = 
 (SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1)));
 
 -- 8. Customers who spent more than the average payments.
 SELECT first_name, last_name FROM customer WHERE customer_id IN 
 (SELECT customer_id FROM payment GROUP BY customer_id
 HAVING SUM(amount) > (SELECT AVG(money_per_customer) AS average_money FROM 
 (SELECT SUM(amount) AS money_per_customer FROM payment GROUP BY customer_id) AS der_table));
 
