SELECT 
	name,
    unit_price AS 'unit price',
    (unit_price * 1.1) AS 'new price'
FROM products;

-- SELECT * FROM orders WHERE order_date >= '2019-01-01';
SELECT * FROM order_items 
WHERE order_id = 6 AND quantity * unit_price > 30;

UPDATE customers
SET customers.state = 'VA' WHERE customers.customer_id = 1;

-- IN
SELECT * FROM customers
WHERE state IN ('VA', 'FL', 'GA');

-- NOT IN
SELECT * FROM customers
WHERE state NOT IN ('VA', 'FL', 'GA');

SELECT * FROM products
WHERE quantity_in_stock IN(49, 38, 72);

-- BETWEEN
SELECT * FROM customers
WHERE points >= 1000 AND points <= 3000;

SELECT * FROM customers
WHERE points BETWEEN 1000 AND 3000;

SELECT * FROM customers
WHERE birth_date BETWEEN '1990/1/1' AND '2000/1/1';

-- LIKE
SELECT * FROM customers
WHERE last_name LIKE 'b____y';
-- % any number of char
-- _ single character

SELECT * FROM customers
WHERE (
		address LIKE '%trail%' OR 
        address LIKE '%avenue%'
);

SELECT * FROM customers
WHERE phone LIKE '%9';

-- REGEX
SELECT * FROM customers
WHERE last_name REGEXP 'field$|^mac|rose';
-- ^ char starts search pattern
-- $ char ends search pattern
-- | for multiple search pattern
-- [abcd] match single char listed on the bracket
-- [a-z] for range

SELECT * FROM customers
WHERE last_name REGEXP '[gim]e';
-- [] searching any character inside bracket.
-- in the example search for ge, ie and me 

SELECT * FROM customers
WHERE last_name REGEXP 'g[eih]';
-- in the example search for ge, gi, gh


SELECT * FROM customers
WHERE last_name REGEXP '[a-z]e';
-- in the example search starts a-z character and e after.

-- EXERCISE REGEXP
SELECT * FROM customers
WHERE first_name REGEXP 'elka|ambur';

SELECT * FROM customers
WHERE last_name REGEXP 'ey$|on$';

SELECT * FROM customers
WHERE last_name REGEXP '^my|se';

SELECT * FROM customers
WHERE last_name REGEXP 'b[ru]';

--
USE sql_store;
INSERT INTO customers(
	first_name, 
    last_name,
    birth_date,
    phone,
    address,
    city,
    state,
    points
) VALUES ('kean','duquS',19890327,3476801934, 'via antonio giovanola', 'manila', 'IT', 2004);

UPDATE customers
SET 
	city = 'milan'
WHERE customer_id = 12;

SELECT * FROM orders WHERE shipped_date IS NULL; 
SELECT * FROM order_items;

SELECT *, (quantity * unit_price) AS total_price FROM order_items
WHERE order_id = 2 
ORDER BY total_price DESC;

SELECT * FROM customers
LIMIT 6,3;

SELECT * FROM customers
ORDER BY points DESC
LIMIT 3;

SELECT order_id, o.customer_id, first_name, last_name 
FROM orders o
JOIN customers c 
	ON o.customer_id = c.customer_id;

    
SELECT * 
FROM products;   
SELECT * 
FROM order_items;  

SELECT order_id, o.product_id, name, quantity, o.unit_price 
FROM order_items o
JOIN products p ON p.product_id = o.product_id;

-- connecting to different db
USE sql_store;

SELECT *
FROM sql_store.order_items o
JOIN products p
	ON o.product_id = p.product_id;

USE sql_hr;

-- SELF JOIN, need to use prefix different
SELECT e.employee_id, e.first_name employee, m.first_name manager
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;

-- JOIN multiple tables

USE sql_store;

SELECT 
	so.order_id, 
    so.order_date, 
    sc.first_name, 
    sc.last_name,
    ss.name status
FROM sql_store.orders so
JOIN sql_store.customers sc ON so.customer_id = sc.customer_id
JOIN sql_store.order_statuses ss ON so.status = ss.order_status_id
ORDER BY order_id ASC;

USE sql_invoicing;

SELECT 
    p.invoice_id,
    p.date,
    p.amount,
    c.name Client, 
    pm.name 'Payment Method'
FROM sql_invoicing.payments p
JOIN sql_invoicing.clients c ON c.client_id = p.client_id
JOIN sql_invoicing.payment_methods pm ON pm.payment_method_id = p.payment_method;

-- COMPOUND JOIN Condition
SELECT * 
FROM order_items oi
JOIN order_items;






























