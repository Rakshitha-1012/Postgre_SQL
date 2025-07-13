//1.List the first name and last name of all customers
SELECT * FROM CUSTOMER;
SELECT first_name,last_name FROM CUSTOMER;


//2.Find all the movies that are currently rented out
SELECT * FROM film;
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT f.title FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.return_date IS NULL;


//3. Show the titles of all movies in the 'Action' category.
SELECT * FROM film_category;
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';


//4. Count the number of films in each category.
SELECT c.name, COUNT(*) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;


//5. What is the total amount spent by each customer?
SELECT * FROM CUSTOMER;
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;


//6. Find the top 5 customers who spent the most.
SELECT * FROM PAYMENT;
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;


//7. Display the rental date and return date for each rental.
SELECT rental_date, return_date FROM rental;


//8. List the names of staff members and the stores they manage.
SELECT s.first_name, s.last_name, st.store_id
FROM staff s
JOIN store st ON s.staff_id = st.manager_staff_id;


//9. Find all customers living in 'California'.
SELECT * FROM COUNTRY;
SELECT c.first_name, c.last_name, co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE a.district = 'California';


//10. Count how many customers are from each city.
SELECT ci.city, COUNT(*) AS customer_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city;


//11. Find the film(s) with the longest duration.
SELECT title, length
FROM film
WHERE length = (SELECT MAX(length) FROM film);


//12. Which actors appear in the film titled 'Alien Center'?
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Alien Center';


//13. Find the number of rentals made each month.
SELECT DATE_TRUNC('month', rental_date) AS month, COUNT(*) AS rental_count
FROM rental
GROUP BY month
ORDER BY month;


//14. Show all payments made by customer 'Mary Smith'.
SELECT p.*
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
WHERE c.first_name = 'Mary' AND c.last_name = 'Smith';


//15. List all films that have never been rented.
SELECT f.title
FROM film f
WHERE f.film_id NOT IN (
    SELECT i.film_id
    FROM inventory i
    JOIN rental r ON i.inventory_id = r.inventory_id
);


//16. What is the average rental duration per category?
SELECT c.name, AVG(f.rental_duration) AS avg_duration
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name;


//17. Which films were rented more than 50 times?
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
HAVING COUNT(*) > 50;


//18. List all employees hired after the year 2005.
SELECT * FROM staff
WHERE last_update > '2005-12-31';


//19. Show the number of rentals processed by each staff member.
SELECT s.first_name, s.last_name, COUNT(*) AS rental_count
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
GROUP BY s.staff_id;


//20. Display all customers who have not made any payments.
SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;


//21. What is the most popular film (rented the most)?
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 1;


//22. Show all films longer than 2 hours.
SELECT title, length
FROM film
WHERE length > 120;


//23. Find all rentals that were returned late.
SELECT r.*
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE return_date > rental_date + (f.rental_duration || ' days')::INTERVAL;


//24. List customers and the number of films they rented.
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS films_rented
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;


//25. Write a query to show top 3 rented film categories.
SELECT c.name AS category, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY rental_count DESC
LIMIT 3;


//26. Create a view that shows all customer names and their payment totals.
CREATE VIEW customer_payment_totals AS
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;


//27. Update a customer's email address given their ID.
UPDATE customer
SET email = 'newemail@example.com'
WHERE customer_id = 1; -- Replace 1 with actual ID


//28. Insert a new actor into the actor table.
INSERT INTO actor (first_name, last_name)
VALUES ('John', 'Doe');


//29. Delete all records from the rentals table where return_date is NULL.
SELECT * FROM rental;
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (155, 2, 1234, 7.98, '2007-05-14 13:44:29');  -- Replace 1234 with valid rental_id

SELECT rental_id FROM rental LIMIT 10;


//30. Add a new column 'age' to the customer table.
ALTER TABLE customer
ADD COLUMN age INT;


//31. Create an index on the 'title' column of the film table.
CREATE INDEX idx_film_title ON film(title);

//32. Find the total revenue generated by each store.
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id;


//33. What is the city with the highest number of rentals?
SELECT ci.city, COUNT(*) AS rental_count
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY rental_count DESC
LIMIT 1;


//34. How many films belong to more than one category?
SELECT COUNT(*) 
FROM (
  SELECT film_id
  FROM film_category
  GROUP BY film_id
  HAVING COUNT(category_id) > 1
) AS multi_cat_films;


//35. List the top 10 actors by number of films they appeared in.
SELECT a.first_name, a.last_name, COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 10;


//36. Retrieve the email addresses of customers who rented 'Matrix Revolutions'.
SELECT DISTINCT c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Matrix Revolutions';


//37. Create a stored function to return customer payment total given their ID.
CREATE OR REPLACE FUNCTION get_customer_payment_total(cid INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(amount) INTO total
    FROM payment
    WHERE customer_id = cid;
    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;


//38. Begin a transaction that updates stock and inserts a rental record.
BEGIN;

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (NOW(), 1, 1, 1); -- replace with actual IDs

COMMIT;


//39. Show the customers who rented films in both 'Action' and 'Comedy' categories.
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE c.customer_id IN (
    SELECT r.customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action'
)
AND c.customer_id IN (
    SELECT r.customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Comedy'
);


//40. Find actors who have never acted in a film.
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;
