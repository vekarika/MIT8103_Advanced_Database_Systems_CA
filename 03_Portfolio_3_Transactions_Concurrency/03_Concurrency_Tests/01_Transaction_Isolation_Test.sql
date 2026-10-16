-- MIT 8103: Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Test 3: Transaction Isolation
-- Case Study: CloudMart E-Commerce Management System

-- Create an isolated test table.
CREATE TABLE IF NOT EXISTS transaction_isolation_test (
    test_id INTEGER PRIMARY KEY,
    test_value TEXT NOT NULL
);

-- Reset only this test table.
TRUNCATE TABLE transaction_isolation_test;

-- Insert the initial value.
INSERT INTO transaction_isolation_test (test_id, test_value)
VALUES (1, 'Initial value');

-- Confirm the initial state.
SELECT * FROM transaction_isolation_test;