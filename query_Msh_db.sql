-- =============================================
-- Author: Kean Duque
-- Create date: 12/19/22
-- Description: SQL test query | Mosh Test
-- =============================================

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
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;

-- IMPLICIT JOIN Syntax
/** 
-- same below query
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
**/
    
-- use implicit join CROSS JOIN (avoid this) be aware on this **********
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

-- OUTER JOIN is LEFT or RIGHT 
SELECT 
	c.customer_id,
	c.first_name,
	o.order_id
FROM orders o
-- JOIN orders o -- doing INNER JOIN 
-- RIGHT OUTER JOIN customers c -- OUTER JOIN is optional
-- LEFT OUTER JOIN customers c -- OUTER JOIN is optional
LEFT OUTER JOIN customers c
	ON c.customer_id = o.customer_id; -- returning records that match

SELECT 
	p.product_id, 
    p.name, 
    oi.quantity
FROM products p
LEFT OUTER JOIN order_items oi
	ON p.product_id = oi.product_id;

-- OUTER JOINS Between Multiple Tables

SELECT
	c.customer_id,
    c.first_name,
    o.order_id,
    s.name Shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers s
	ON o.shipper_id = s.shipper_id
ORDER BY c.customer_id;

-- exercise
SELECT
	o.order_date,
    o.order_id,
    c.first_name,
    sh.name shipper,
    ost.name status
FROM orders o
JOIN customers c
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON sh.shipper_id = o.shipper_id
LEFT JOIN order_statuses ost
	ON ost.order_status_id = o.status
ORDER BY shipper;

-- SELF OUTER JOIN

USE sql_hr;

SELECT
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON m.employee_id = e.reports_to
ORDER BY manager ASC;

-- THE USING close -- can use only with same column in different tables
SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer_id;
    USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	USING (order_id, product_id);


SELECT
	p.date,
    c.name client,
    p.amount,
    pm.name 'Payment Method'
FROM payments p
JOIN clients c
	USING (client_id)
JOIN payment_methods pm
	ON pm.payment_method_id = p.payment_method;
    
    
-- NATURAL JOIN (Not Recommend) Guessing joins. producing unexpected results.
SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;

-- CROSS JOIN (best to use for Sizes, color or variants)

SELECT 
	c.first_name AS customer,
    p.name AS product
-- FROM customers c, products p -- IMPLICIT SYNTAX    
FROM customers c
-- EXPLICIT SYNTAX
CROSS JOIN products p 
ORDER BY first_name;

-- IMPLICIT
SELECT 
	s.name as shipper,
    p.name as product
FROM products p, shippers s
ORDER BY s.name ASC;

-- EXPLICIT
SELECT 
	s.name as shipper,
    p.name as product
FROM products p
CROSS JOIN shippers s
ORDER BY s.name ASC;

-- UNION to combined records from multiple queries to rows
SELECT 
	order_id,
    order_date,
    'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT 
	order_id,
    order_date,
    'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers;

SELECT
	customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name ASC;

-- INSERT ROW to TABLE

INSERT INTO customers (
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state
)
VALUES(
    'Shinichi',
    'Kudo',
    '1990-01-01',
    'koga shi',
    'ibaraki',
    'JP'
);
SELECT * FROM customers;

-- INSERTING Multiple Rows

INSERT INTO shippers(name)
VALUES
	('Shipper1'),
    ('Shipper2'),
    ('Shipper3');
    
INSERT INTO products(
	name,
    quantity_in_stock,
    unit_price
)
VALUES
	('cottolete',100,2.30),
    ('mouse',200,14),
    ('keyboard',520,23);
    
-- INSERTING Hierarchical Rows

INSERT INTO orders(customer_id, order_date, status)
VALUES (13, '2019-02-04', 1);

SELECT LAST_INSERT_ID();  
-- Return the AUTO_INCREMENT id of the last row that has been inserted or updated in a table:
INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1,1,2.95),
    (LAST_INSERT_ID(), 2,1,3.95);
    
-- CREATE a copy of a TABLE
CREATE TABLE orders_archived AS
SELECT * FROM orders; -- subquery part of another sql statement at top.

INSERT INTO orders_archived -- no need to put the () since you will copy all the columns from order.
SELECT *  -- subquery in an insert statement.
FROM orders
WHERE order_date < '2019-01-01';

USE sql_invoicing;

/*
Exercise : 
in invoices table
id, number, client_id, followed with other columns
invoices_archived instead of client_id col we need a client name column.
JOIN with the clients table and use that query as subquery in a CREATE TABLE statement
copy only invoices that have payment_date
*/
USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT 
	i.invoice_id,
    i.number,
    c.name as client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices i
JOIN clients c
	USING(client_id)
WHERE payment_date IS NOT NULL;

-- Updating a single row

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5, 
	payment_date = due_date
WHERE invoice_id = 1;

SELECT * FROM invoices;

-- Updating a multiple row

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5, 
	payment_date = due_date
WHERE client_id = 3;
-- WHERE client_id IN (3,4);

SELECT * 
FROM customers
WHERE birth_date <= '1990-01-01';

UPDATE customers
SET points = points + 50
WHERE birth_date <= '1990-01-01';

-- USING Subqueries in Updates





























