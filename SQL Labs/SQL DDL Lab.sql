USE sakila;

-- 1.- Get release years
SELECT title, release_year
FROM film;

-- 2. Get all films with ARMAGEDDON in the title.
SELECT title
FROM film
WHERE title LIKE "%Armageddon%";

-- 3. Get all films which title ends with APOLLO.
SELECT title
FROM film
WHERE title LIKE "%Apollo";

-- 4.- Get 10 the longest films.
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 10;

-- 5. How many films include **Behind the Scenes** content?
SELECT COUNT(film_id)
FROM film
WHERE special_features="Behind the Scenes";

-- 6. Drop column `picture` from `staff`.
ALTER TABLE staff
DROP COLUMN picture;

/* 7. A new person is hired to help Jon. Her name is TAMMY SANDERS, 
and she is a customer. Update the database accordingly. */

-- Check the store_id where Jon works. It is store number 2:
SELECT *
FROM staff;

-- Check Tammys' data:
SELECT * 
FROM customer
WHERE first_name="Tammy";

-- The information we need is: address_id = 79, email= TAMMY.SANDERS@sakilastaff.com, active = 1, username = Tammy
INSERT INTO staff (first_name, last_name, address_id, email, `active`, username, store_id)
VALUES ("TAMMY", "SANDERS", 79, "TAMMY.SANDERS@sakilastaff.com", 1, "Tammy", 2);
-- We check it worked:
SELECT * FROM staff;

/* 8.- Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
You can use current date for the `rental_date` column in the `rental` table. */
-- Check information needed to add a rental:
SELECT * FROM rental WHERE rental_id IN (1,2,3,4,5);
/* We need inventory_id, which we will get with the store_id=1 and the film_id (need to check). 
Also the customer_id and staff_id*/
SELECT film_id FROM film WHERE title="Academy Dinosaur"; -- The film_id is 1
SELECT inventory_id FROM inventory WHERE store_id = 1 AND film_id = 
(SELECT film_id FROM film WHERE title="Academy Dinosaur"); -- The inventory_id can be 1 to 4
SELECT customer_id FROM customer WHERE first_name="Charlotte" AND last_name="Hunter"; -- customer_id=130
SELECT staff_id FROM staff WHERE store_id=1; -- staff_id=1

-- Now we can insert the new row
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES ("2021-08-25", 1, 130, 1);

-- Check the results:
SELECT * FROM rental WHERE inventory_id=1;

/* 9. Delete non-active users, but first, create a _backup table_ `deleted_users` 
to store `customer_id`, `email`, and the `date` for the users that would be deleted. Follow these steps:
   - Check if there are any non-active users
   - Create a table _backup table_ as suggested
   - Insert the non active users in the table _backup table_
   - Delete the non active users from the table customer
*/
SELECT * FROM customer WHERE `active`=0; -- There are 15 non active users

-- Create the table:
CREATE TABLE backup_table (customer_id INT, email VARCHAR(50), 
deletion_date DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (customer_id) ); 

-- Populate the table
INSERT INTO backup_table (customer_id, email)
SELECT customer_id, email FROM customer WHERE `active`=0;  

-- Check it worked:
SELECT * FROM backup_table;

-- Delete from customer table the relevant records:
DELETE FROM customer
WHERE `active`=0 AND customer_id IN (SELECT customer_id FROM backup_table);
-- It doesn't let me delete the customers because there are references in the payment table to their customer_id:
SELECT * FROM payment
WHERE customer_id IN (SELECT customer_id FROM backup_table);

DROP TABLE backup_table;




 
 
