/*



/* 1.-Write a query to display for each store its store ID, city, and country.*/
SELECT store.store_id, city.city, country.country
FROM store INNER JOIN address ON store.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON country.country_id=city.country_id;

/* 2.- Write a query to display how much business, in dollars, each store brought in. */
SELECT store.store_id, SUM(payment.amount) AS dollars_per_store
FROM store INNER JOIN staff ON store.store_id=staff.store_id
INNER JOIN payment ON payment.staff_id=staff.staff_id
GROUP BY store.store_id;

/* 3.-What is the average running time of films by category? */
SELECT category.name, AVG(film.length)  AS average_length_minutes
FROM category INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN film ON film.film_id=film_category.film_id
GROUP BY category.category_id
ORDER BY average_length_minutes DESC;

/* 4.-Which film categories are longest? - I think it's the same question? */
SELECT category.name, AVG(film.length)  AS average_length_minutes
FROM category INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN film ON film.film_id=film_category.film_id
GROUP BY category.category_id
ORDER BY average_length_minutes DESC;

/* 5.- Display the most frequently rented movies in descending order */
SELECT film.title, COUNT(rental.rental_id) AS total_rentals
FROM film 
INNER JOIN inventory ON film.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY film.film_id
ORDER BY total_rentals DESC;

/* 6.- List the top five genres in gross revenue in descending order. */
SELECT category.name, SUM(payment.amount) AS revenue
FROM category INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN film ON film.film_id=film_category.film_id
INNER JOIN inventory ON inventory.film_id=film.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY revenue DESC
LIMIT 5;

/* 7.- Is "Academy Dinosaur" available for rent from Store 1?*/
SELECT film.title, COUNT(film.title) AS number_of_copies
FROM film INNER JOIN inventory ON film.film_id=inventory.film_id
INNER JOIN store ON store.store_id=inventory.store_id
WHERE store.store_id=1 AND film.title="Academy Dinosaur";



