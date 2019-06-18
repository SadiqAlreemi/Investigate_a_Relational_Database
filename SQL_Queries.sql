
/* Slide 1 || What are the most famous family films? */

/* Start SQL query for slide 1 */

	SELECT DISTINCT(f.title) film_title,
		   					 c.name category_name,
		   			 		 COUNT(r.rental_date)
								 	OVER (
										PARTITION BY f.title
										ORDER BY f.title) AS rental_count
	FROM  film f
				JOIN film_category fc
					ON f.film_id = fc.film_id
				JOIN category c
					ON fc.category_id = c.category_id
				JOIN inventory i
					ON f.film_id = i.film_id
				JOIN rental r
					ON i.inventory_id = r.inventory_id
	WHERE c.name = 'Animation'
			   OR c.name = 'Children'
			   OR c.name = 'Classics'
			   OR c.name = 'Comedy'
			   OR c.name = 'Family'
			   OR c.name = 'Music'
	ORDER BY c.name,
					 f.title;

/* End SQL query for slide 1 */


/* Slide 2 || What is the distribution of family films compared to other film categories and duration of rent? */

/* Start SQL query for slide 2 */

SELECT category_name,
  			 standard_quartile,
  		 	 COUNT(*)
FROM
  (
    SELECT film_title,
      		 category_name,
      		 rental_duration,
      		 NTILE(4) OVER (
        		 ORDER BY rental_duration) AS standard_quartile
    FROM
      (
        SELECT
          f.title film_title,
          c.name category_name,
          f.rental_duration rental_duration
        FROM film f
	           JOIN film_category fc
						   ON f.film_id = fc.film_id
	           JOIN category c
						 	 ON fc.category_id = c.category_id
        WHERE c.name = 'Animation'
		          OR c.name = 'Children'
		          OR c.name = 'Classics'
		          OR c.name = 'Comedy'
		          OR c.name = 'Family'
		          OR c.name = 'Music') t1
    ORDER BY  rental_duration) t2
GROUP BY 1, 2

/* End SQL query for slide 2 */


/* Slide 3 || How to compare stores in the number of rental requests? */

/* Start SQL query for slide 3 */

SELECT DATE_PART('month', r.rental_date) AS rental_month,
	     DATE_PART('year', r.rental_date) AS rental_year,
       sto.store_id,
       COUNT(*) AS rental_count
FROM rental r
  	 JOIN payment p
		  ON r.rental_id = p.rental_id
     JOIN staff sta
		  ON p.staff_id = sta.staff_id
     JOIN store sto
		  ON sta.store_id = sto.store_id
GROUP BY rental_month,
			 rental_year,
		   sto.store_id
ORDER BY rental_count DESC;

/* End SQL query for slide 3 */


/* Slide 4 || How to compare stores in the number of rental requests? */

/* Start SQL query for slide 4 */
WITH t1 AS (
  SELECT first_name || ' ' || last_name AS fullname,
    		 SUM(p.amount) AS total_amount
  FROM customer c
    JOIN payment p
			ON c.customer_id = p.customer_id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 10)
SELECT fullname,
  		 total_amount
FROM t1;
/* End SQL query for slide 4 */
