-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

INSERT INTO subcontractor(name, address, postal_code, email)
VALUES ("ali naeimi", "tehran-mofateh st-goharderakhshan", 111111, "email@email.com");

INSERT INTO material(type, availability, stock)
VALUES ("metal", "TRUE", 11);

SELECT customer_id, name, location FROM customer;

SELECT c.name AS customer, o.order_id, o.date, SUM(oi.quantity * p.price) AS total_price
FROM customer c
JOIN order o ON c.customer_id = o.customer_id
JOIN order_item oi ON o.order_id = oi.order_id
JOIN product p ON oi.product_id = p.product_id
GROUP BY c.name, o.order_id, o.date;


SELECT COUNT(*) AS total_customers FROM customer;

SELECT COUNT(*) AS active_orders FROM order WHERE status = 'Active';

SELECT MIN(price) AS lowest_price, MAX(price) AS highest_price FROM product;

SELECT SUM(quantity) AS total_units_sold FROM order_item;

SELECT AVG(total_price) AS average_order_value FROM order;

UPDATE customer SET email = 'new_email@email.com' WHERE customer_id = 123;

DELETE FROM invoice WHERE payment_status = 'Paid';

SELECT * FROM product WHERE price > 50 AND category = 'Electronics';


SELECT * FROM customer ORDER BY name DESC;


SELECT * FROM customer
WHERE customer_id IN (
  SELECT customer_id FROM order
  WHERE order_date > '2024-01-01'
);


SELECT name, email FROM customer
UNION ALL
SELECT name, contact_email AS email FROM subcontractor;
