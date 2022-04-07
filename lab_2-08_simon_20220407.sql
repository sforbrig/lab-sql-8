USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
SELECT
	s.store_id
    ,c.city
    ,co.country
FROM store s
	JOIN address a ON a.address_id = s.address_id
    JOIN city c ON c.city_id = a.city_id
    JOIN country co ON co.country_id = c.country_id
;

-- 2. Write a query to display how much business, in dollars, each store brought in.
SELECT
	s.store_id
    ,SUM(p.amount) AS 'business_in_dollars'
FROM store s
	JOIN payment p ON p.staff_id = s.manager_staff_id
    GROUP BY s.manager_staff_id
;
    
-- 3. Which film categories are longest?
SELECT
	c.category_id
    ,c.name
    ,ROUND(AVG(f.length),0) AS 'average_film_length'
FROM category c
	JOIN film_category fc ON fc.category_id = c.category_id
    JOIN film f ON f.film_id = fc.film_id
		GROUP BY c.category_id
        ORDER BY average_film_length DESC
;
    
-- 4. Display the most frequently rented movies in descending order.
SELECT
	f.film_id
    ,f.title
    ,COUNT(r.inventory_id) AS 'sum_of_rents'
FROM rental r
	JOIN inventory i ON i.inventory_id = r.inventory_id
    JOIN film f ON f.film_id = i.film_id
    GROUP BY f.film_id
    ORDER BY sum_of_rents DESC
;

-- 5.List the top five genres in gross revenue in descending order.
SELECT
	c.name AS 'film_category'
    ,SUM(p.amount) AS 'gross_revenue'
FROM category c
	JOIN film_category fc ON fc.category_id = c.category_id
    JOIN film f ON f.film_id = fc.film_id
	JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
    JOIN payment p ON p.rental_id = r.rental_id
		GROUP BY c.name
        ORDER BY gross_revenue DESC
        LIMIT 5
;
    
-- 6. Is "Academy Dinosaur" available for rent from Store 1?
SELECT
	f.title
    ,r.return_date
FROM film f
	JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id 
		WHERE r.return_date IS NULL 
			AND
            r.staff_id = 1
            AND f.title = 'Academy Dinosaur'
;
-- no result = is avalible in store 1! For store 2 result is NULL =  not avalible.

-- 7. Get all pairs of actors that worked together.
SELECT DISTINCT
	fa1.film_id
    ,fa1.actor_id
    ,a.first_name
    ,a.last_name
    ,fa2.actor_id
    ,a1.first_name
    ,a1.last_name
FROM film_actor fa1
	JOIN film_actor fa2 ON fa2.film_id = fa1.film_id
    JOIN actor a ON a.actor_id = fa1.actor_id
    JOIN actor a1 ON a1.actor_id = fa2.actor_id
		WHERE a.actor_id != a1.actor_id
		ORDER BY fa1.film_id
;
    
-- 8. Get all pairs of customers that have rented the same film more than 3 times.
SELECT DISTINCT
	i.film_id
    ,r1.customer_id
    ,c1.first_name
    ,c1.last_name
    ,r2.customer_id
    ,c2.first_name
    ,c2.last_name
FROM rental r1
	JOIN rental r2 ON r2.inventory_id = r1.inventory_id
    JOIN customer c1 ON c1.customer_id = r1.customer_id
    JOIN customer c2 ON c2.customer_id = r2.customer_id
    JOIN inventory i ON i.inventory_id = r1.inventory_id
		WHERE c1.customer_id != c2.customer_id 
		ORDER BY i.film_id
;
-- SUBQUERRY needed I guess...

-- 9. For each film, list actor that has acted in more films.
-- SUBQUERRY needed I guess...