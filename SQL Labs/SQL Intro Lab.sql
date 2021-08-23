/* We select the films from the film table */
SELECT title FROM sakila.film;

/*Select one column from a table and alias it. Get unique list of film 
languages under the alias language.*/
SELECT DISTINCT name AS language FROM sakila.language; 

/*how many stores does the company have?*/
SELECT COUNT(store_id) FROM sakila.store;
/*They have two stores*/

/*How many employees does the company have? */
SELECT COUNT(staff_id) FROM sakila.staff;
/*They have two employees*/

/*Their first names*/
SELECT first_name FROM sakila.staff;