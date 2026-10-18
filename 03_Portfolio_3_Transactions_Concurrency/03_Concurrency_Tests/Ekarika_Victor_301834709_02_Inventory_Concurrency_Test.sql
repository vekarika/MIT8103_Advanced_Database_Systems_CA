-- Portfolio 3: Inventory Concurrency Control
-- Database: cloudmart_db
-- DBMS: PostgreSQL 18.6

-- Create a dedicated test table.
CREATE TABLE IF NOT EXISTS inventory_concurrency_test (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0)
);

-- Reset the test data for repeatable execution.
DELETE FROM inventory_concurrency_test
WHERE product_id = 9001;

INSERT INTO inventory_concurrency_test (
    product_id,
    product_name,
    quantity
)
VALUES (
    9001,
    'CloudMart Concurrency Test Product',
    5
)
ON CONFLICT (product_id)
DO UPDATE SET quantity = EXCLUDED.quantity;

-- Display the initial inventory quantity.
SELECT product_id, product_name, quantity
FROM inventory_concurrency_test
WHERE product_id = 9001;

-- Demonstrate a safe stock deduction.
BEGIN;

UPDATE inventory_concurrency_test
SET quantity = quantity - 3
WHERE product_id = 9001
  AND quantity >= 3;

-- Verify the updated inventory.
SELECT product_id, product_name, quantity
FROM inventory_concurrency_test
WHERE product_id = 9001;

COMMIT;

-- Verify the committed quantity.
SELECT product_id, product_name, quantity
FROM inventory_concurrency_test
WHERE product_id = 9001;