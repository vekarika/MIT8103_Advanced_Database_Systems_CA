-- ============================================================
-- CloudMart E-Commerce Management System
-- MIT 8103 - Advanced Database Systems
-- Portfolio 1: Sample Data
-- PostgreSQL 18
-- ============================================================

BEGIN;

-- 1. CUSTOMERS
INSERT INTO customer
    (first_name, last_name, email, phone, status)
VALUES
    ('Ada', 'Okafor', 'ada.okafor@example.com', '08030000001', 'active'),
    ('Emeka', 'Bello', 'emeka.bello@example.com', '08030000002', 'active'),
    ('Fatima', 'Yusuf', 'fatima.yusuf@example.com', '08030000003', 'active'),
    ('Daniel', 'Mensah', 'daniel.mensah@example.com', '08030000004', 'inactive'),
    ('Grace', 'Eze', 'grace.eze@example.com', '08030000005', 'active');

-- 2. ADDRESSES
INSERT INTO address
    (customer_id, address_line, city, state_region, postal_code,
     country, address_type)
VALUES
    (1, '12 Market Road', 'Abuja', 'FCT', '900001', 'Nigeria', 'shipping'),
    (1, '14 Market Road', 'Abuja', 'FCT', '900001', 'Nigeria', 'billing'),
    (2, '8 Garden Avenue', 'Lagos', 'Lagos', '100001', 'Nigeria', 'both'),
    (3, '21 Unity Street', 'Kano', 'Kano', '700001', 'Nigeria', 'both'),
    (4, '5 River Close', 'Uyo', 'Akwa Ibom', '520001', 'Nigeria', 'both'),
    (5, '17 Hill Road', 'Enugu', 'Enugu', '400001', 'Nigeria', 'both');

-- 3. CATEGORIES
INSERT INTO category
    (category_name, description)
VALUES
    ('Electronics', 'Electronic devices and accessories'),
    ('Computing', 'Computers and computing accessories'),
    ('Home Appliances', 'Appliances for domestic use');

-- 4. PRODUCTS
INSERT INTO product
    (category_id, product_name, description, selling_price, status)
VALUES
    (1, 'Wireless Headphones', 'Wireless over-ear headphones', 45000.00, 'active'),
    (1, 'Bluetooth Speaker', 'Portable Bluetooth speaker', 65000.00, 'active'),
    (2, 'Laptop Stand', 'Adjustable aluminium laptop stand', 18000.00, 'active'),
    (2, 'USB-C Hub', 'Multiport USB-C adapter', 32000.00, 'active'),
    (3, 'Electric Kettle', '1.7-litre electric kettle', 22000.00, 'active'),
    (1, 'USB Cable', 'USB-C charging cable', 5000.00, 'active');

-- 5. INVENTORY
INSERT INTO inventory
    (product_id, quantity_available, reorder_level)
VALUES
    (1, 25, 5),
    (2, 15, 4),
    (3, 40, 8),
    (4, 20, 5),
    (5, 18, 4),
    (6, 100, 20);

-- 6. CUSTOMER ORDERS
INSERT INTO customer_order
    (customer_id, delivery_address_id, order_status)
VALUES
    (1, 1, 'confirmed'),
    (2, 3, 'processing'),
    (3, 4, 'pending'),
    (5, 6, 'shipped');

-- 7. ORDER ITEMS
INSERT INTO order_item
    (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 45000.00),
    (1, 6, 2, 5000.00),
    (2, 2, 1, 65000.00),
    (2, 3, 2, 18000.00),
    (3, 4, 1, 32000.00),
    (4, 5, 1, 22000.00);

-- 8. PAYMENTS
INSERT INTO payment
    (order_id, amount, payment_method, transaction_reference,
     payment_status, payment_date)
VALUES
    (1, 55000.00, 'card', 'CM-PAY-0001', 'successful', CURRENT_TIMESTAMP),
    (2, 101000.00, 'bank_transfer', 'CM-PAY-0002', 'successful', CURRENT_TIMESTAMP),
    (3, 32000.00, 'card', 'CM-PAY-0003', 'pending', NULL),
    (4, 22000.00, 'bank_transfer', 'CM-PAY-0004', 'successful', CURRENT_TIMESTAMP);

-- 9. DELIVERIES
INSERT INTO delivery
    (order_id, tracking_number, delivery_status, dispatch_date, delivery_date)
VALUES
    (1, 'CM-TRK-0001', 'delivered',
        CURRENT_TIMESTAMP - INTERVAL '3 days',
        CURRENT_TIMESTAMP - INTERVAL '1 day'),
    (2, 'CM-TRK-0002', 'in_transit',
        CURRENT_TIMESTAMP - INTERVAL '1 day',
        NULL),
    (4, 'CM-TRK-0004', 'dispatched',
        CURRENT_TIMESTAMP,
        NULL);

COMMIT;

-- ============================================================
-- END OF SAMPLE DATA
-- ============================================================