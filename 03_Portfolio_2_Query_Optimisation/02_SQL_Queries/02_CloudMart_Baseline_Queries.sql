/*
MIT 8103: Advanced Database Systems
Portfolio 2: Query Processing and Optimisation
Project: CloudMart E-Commerce Management System

File: 02_CloudMart_Baseline_Queries.sql

Purpose:
Establish baseline SQL queries for business reporting and
subsequent execution-plan and indexing analysis.
*/

-- QR-01: Customer Order History
-- Retrieve each order for customer ID 1 and calculate its total.

SELECT
    co.order_id,
    co.order_date,
    co.order_status,
    COUNT(oi.order_item_id) AS item_count,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM customer_order AS co
JOIN order_item AS oi
    ON oi.order_id = co.order_id
WHERE co.customer_id = 1
GROUP BY
    co.order_id,
    co.order_date,
    co.order_status
ORDER BY co.order_date DESC;

-- QR-02: Order Details
-- Retrieve the products and amounts for order ID 1.

SELECT
    oi.order_item_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_subtotal
FROM order_item AS oi
JOIN product AS p
    ON p.product_id = oi.product_id
WHERE oi.order_id = 1
ORDER BY p.product_name;

-- QR-03: Active Product Catalogue
-- Retrieve active products and their categories.

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.selling_price
FROM product AS p
JOIN category AS c
    ON c.category_id = p.category_id
WHERE p.status = 'active'
ORDER BY p.product_name;

-- QR-04: Low-Stock Inventory
-- Identify products at or below their reorder levels.

SELECT
    p.product_id,
    p.product_name,
    i.quantity_available,
    i.reorder_level
FROM inventory AS i
JOIN product AS p
    ON p.product_id = i.product_id
WHERE i.quantity_available <= i.reorder_level
ORDER BY i.quantity_available ASC;

-- QR-05: Customer Order Summary
-- Count each customer's orders and calculate their total order value.

SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(DISTINCT co.order_id) AS order_count,
    COALESCE(
        SUM(oi.quantity * oi.unit_price),
        0
    ) AS total_order_value
FROM customer AS c
LEFT JOIN customer_order AS co
    ON co.customer_id = c.customer_id
LEFT JOIN order_item AS oi
    ON oi.order_id = co.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_order_value DESC;

-- QR-06: Revenue by Product
-- Calculate the value of all recorded order items by product.

SELECT
    p.product_id,
    p.product_name,
    COALESCE(
        SUM(oi.quantity * oi.unit_price),
        0
    ) AS total_item_value
FROM product AS p
LEFT JOIN order_item AS oi
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_item_value DESC;

-- QR-07: Order Status Summary
-- Count orders grouped by their current status.

SELECT
    order_status,
    COUNT(*) AS order_count
FROM customer_order
GROUP BY order_status
ORDER BY order_count DESC, order_status;

-- QR-08: Customer Order Search
-- Retrieve customer 1's orders within a specified date range.
-- The range includes 1 January 2026 and excludes 1 January 2027.

SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM customer_order
WHERE customer_id = 1
  AND order_date >= TIMESTAMPTZ '2026-01-01 00:00:00+00'
  AND order_date <  TIMESTAMPTZ '2027-01-01 00:00:00+00'
ORDER BY order_date DESC;