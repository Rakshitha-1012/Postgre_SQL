show tables;
select * from new_schema.employee;

#1.Who is the senior most employee based on job title
Select * from new_schema.employee order by levels desc limit 1;

#2. Which countries have the most Invoices
select * from new_schema.customer;
select * from new_schema.invoice;
SELECT billing_country, COUNT(*) AS InvoiceCount
FROM new_schema.invoice
GROUP BY billing_country
ORDER BY InvoiceCount DESC;


#3. What are top 3 values of total invoice
SELECT total
FROM new_schema.invoice
ORDER BY total DESC limit 3;


#4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns 
#one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
select * from new_schema.invoice;
select billing_country, sum(total) as Total_revenue
from new_schema.invoice 
group by billing_country
order by Total_revenue desc limit 1;


#5. Who is the best customer? 
#The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
Select * from new_schema.invoice;
select c.customer_id,c.first_name,c.last_name,sum(i.total) as Total_revenue from new_schema.customer c
join new_schema.invoice i on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name
order by Total_revenue desc limit 1;

#MODERATE
#1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
# Return your list ordered alphabetically by email starting with A
Select * from new_schema.playlist_track;
Select * from new_schema.genre;
Select * from new_schema.track;
Select * from new_schema.invoice;
Select * from new_schema.invoice_line;

Select distinct c.first_name, c.last_name, c.email, g.name as Genre_name
from new_schema.customer c
join new_schema.invoice i on c.customer_id=i.customer_id
join new_schema.invoice_line il on i.invoice_id=il.invoice_id
join new_schema.track t on il.track_id=t.track_id
join new_schema.genre g on t.genre_id=g.genre_id
where g.name='Rock'
order by c.email asc ;


#2. Let's invite the artists who have written the most rock music in our dataset.
 #Write a query that returns the Artist name and total track count of the top 10 rock bands
 
Select * from new_schema.album2;
Select * from new_schema.track;
Select * from new_schema.artist;

Select a.name as Artist_name, sum(t.track_id) as Total_track
from new_schema.artist a
join new_schema.album2 ab on a.artist_id=ab.artist_id
join new_schema.track t on ab.album_id=t.album_id
join new_schema.genre g on t.genre_id=g.genre_id
where g.name='Rock'
group by a.name
order by Total_track desc limit 10;


#3. Return all the track names that have a song length longer than the average song length.
#Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

SELECT name, milliseconds
FROM new_schema.track
WHERE milliseconds > (
    SELECT AVG(milliseconds) FROM new_schema.track)
ORDER BY milliseconds DESC;


#ADVANCE
#1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

select * from new_schema.customer;
select * from new_schema.artist;

SELECT c.first_name, c.last_name,a.name AS artist_name,SUM(il.unit_price * il.quantity) AS total_spent
FROM new_schema.customer c
JOIN new_schema.invoice i ON c.customer_id = i.customer_id
JOIN new_schema.invoice_line il ON i.invoice_id = il.invoice_id
JOIN new_schema.track t ON il.track_id = t.track_id
JOIN new_schema.album2 al ON t.album_id = al.album_id
JOIN new_schema.artist a ON al.artist_id = a.artist_id
GROUP BY c.first_name,c.last_name, artist_name
ORDER BY total_spent DESC;


#2. We want to find out the most popular music Genre for each country. 
#We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre.
#For countries where the maximum number of purchases is shared return all Genres

SELECT c.country, g.name AS genre, COUNT(*) AS purchase_count
FROM new_schema.customer c
JOIN new_schema.invoice i ON c.customer_id = i.customer_id
JOIN new_schema.invoice_line il ON i.invoice_id = il.invoice_id
JOIN new_schema.track t ON il.track_id = t.track_id
JOIN new_schema.genre g ON t.genre_id = g.genre_id
GROUP BY c.country, g.name
ORDER BY c.country, purchase_count DESC;


WITH GenrePurchaseCounts AS (
    SELECT 
        c.country,
        g.name AS genre,
        COUNT(*) AS purchase_count
    FROM new_schema.customer c
    JOIN new_schema.invoice i ON c.customer_id = i.customer_id
    JOIN new_schema.invoice_line il ON i.invoice_id = il.invoice_id
    JOIN new_schema.track t ON il.track_id = t.track_id
    JOIN new_schema.genre g ON t.genre_id = g.genre_id
    GROUP BY c.country, g.name
),
RankedGenres AS (
    SELECT *,
           RANK() OVER (PARTITION BY country ORDER BY purchase_count DESC) AS genre_rank
    FROM GenrePurchaseCounts
)
SELECT country, genre, purchase_count
FROM RankedGenres
WHERE genre_rank = 1
ORDER BY country;



#3. Write a query that determines the customer that has spent the most on music for each country. 
#Write a query that returns the country along with the top customer and how much they spent. 
#For countries where the top amount spent is shared, provide all customers who spent this amount

SELECT c.country, c.first_name, c.last_name, SUM(i.total) AS total_spent
FROM new_schema.customer c
JOIN new_schema.invoice i ON c.customer_id = i.customer_id
GROUP BY c.country, c.first_name, c.last_name
ORDER BY c.country, total_spent DESC;


WITH CustomerSpending AS (
    SELECT 
        c.country,
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spent
    FROM new_schema.customer c
    JOIN new_schema.invoice i ON c.customer_id = i.customer_id
    GROUP BY c.country, c.customer_id, c.first_name, c.last_name
),
RankedSpending AS (
    SELECT *,
           RANK() OVER (PARTITION BY country ORDER BY total_spent DESC) AS spending_rank
    FROM CustomerSpending
)
SELECT country, first_name, last_name, total_spent
FROM RankedSpending
WHERE spending_rank = 1
ORDER BY country;
WITH CustomerSpending AS (
    SELECT 
        c.country,
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spent
    FROM new_schema.customer c
    JOIN new_schema.invoice i ON c.customer_id = i.customer_id
    GROUP BY c.country, c.customer_id, c.first_name, c.last_name
),
RankedSpending AS (
    SELECT *,
           RANK() OVER (PARTITION BY country ORDER BY total_spent DESC) AS spending_rank
    FROM CustomerSpending
)
SELECT country, first_name, last_name, total_spent
FROM RankedSpending
WHERE spending_rank = 1
ORDER BY country;
