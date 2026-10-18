-- MIT 8103: Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Test 2: ROLLBACK
-- Case Study: CloudMart E-Commerce Management System

-- Create an isolated temporary table.
CREATE TEMPORARY TABLE transaction_rollback_test (
    test_id INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);

-- Start a transaction.
BEGIN;

-- Insert a test record.
INSERT INTO transaction_rollback_test (test_id, description)
VALUES (1, 'CloudMart ROLLBACK demonstration');

-- Verify the record exists before rollback.
SELECT * FROM transaction_rollback_test;

-- Cancel the transaction.
ROLLBACK;

-- Verify that the inserted record was discarded.
SELECT COUNT(*) AS records_after_rollback
FROM transaction_rollback_test;