USE sakila;

/*1.- How many films are there for each of the categories in the category table. 
Use appropriate join to write this query */
SELECT DISTINCT category.name, COUNT(film_category.film_id) 
FROM category
INNER JOIN film_category
ON category.category_id=film_category.category_id
GROUP BY category.name;

/* 2.- Which actor has appeared in the most films? */
SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS total_films_acted
FROM actor
INNER JOIN film_actor
ON actor.actor_id=film_actor.actor_id
GROUP BY actor.actor_id
ORDER BY total_films_acted DESC
LIMIT 1;

/*3.- Most active customer (the customer that has rented the most number of films) */
SELECT customer.first_name, customer.last_name, COUNT(rental_id) AS total_rented
FROM customer
INNER JOIN rental
ON customer.customer_id=rental.customer_id
GROUP BY rental.customer_id
ORDER BY total_rented DESC
LIMIT 1;

/* 4.- List number of films per category. It's the same as number 1 */
SELECT DISTINCT category.name, COUNT(film_category.film_id) 
FROM category
INNER JOIN film_category
ON category.category_id=film_category.category_id
GROUP BY category.name;

/* 5.- Display the first and last names, as well as the address, of each staff member. */
SELECT staff.first_name, staff.last_name, address.address, city.city
FROM staff 
INNER JOIN address ON staff.address_id=address.address_id
INNER JOIN city ON city.city_id=address.city_id;

/* 6.- Display the total amount rung up by each staff member in August of 2005. */
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS amount_per_employee
FROM staff INNER JOIN payment ON staff.staff_id=payment.staff_id
WHERE payment.payment_date BETWEEN "2005-08-01" AND "2005-08-31"
GROUP BY staff.staff_id;

/* 7.-List each film and the number of actors who are listed for that film.*/
SELECT film.title, COUNT(film_actor.actor_id) AS number_of_actors
FROM film LEFT JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.film_id
ORDER BY number_of_actors DESC;

/* 8.- Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name*/
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_paid
FROM customer INNER JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name ASC;

/*Bonus: Which is the most rented film? 
The answer is Bucket Brotherhood This query might require using more than one join statement. Give it a try.*/
SELECT film.title, COUNT(rental.rental_id) AS total_rentals
FROM film 
INNER JOIN inventory ON film.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY film.film_id
ORDER BY total_rentals DESC;

