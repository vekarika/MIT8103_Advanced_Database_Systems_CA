-- MIT 8103: Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Test 1: COMMIT
-- Case Study: CloudMart E-Commerce Management System

-- Create a temporary test table for this demonstration.
-- The table is temporary and will disappear when the session ends.

CREATE TEMPORARY TABLE transaction_commit_test (
    test_id INTEGER PRIMARY KEY,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Begin a transaction.
BEGIN;

-- Insert a test record.
INSERT INTO transaction_commit_test (test_id, description)
VALUES (1, 'CloudMart COMMIT demonstration');

-- Verify the record exists within the transaction.
SELECT * FROM transaction_commit_test;

-- Commit the transaction.
COMMIT;

-- Verify the record remains available in the current session.
SELECT * FROM transaction_commit_test;