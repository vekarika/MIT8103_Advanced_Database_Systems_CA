/*
MIT 8103: Advanced Database Systems
Portfolio 2: Query Processing and Optimisation

Experiment:
Evaluate an index on customer_order(customer_id).

Purpose:
Support queries that retrieve orders belonging to a specific
customer.

Baseline:
QR-01 previously used a sequential scan on customer_order.

Hypothesis:
The index may improve customer-specific order retrieval as
the table grows. Improvement is not guaranteed for the current
small dataset.
*/

CREATE INDEX IF NOT EXISTS idx_customer_order_customer_id
    ON customer_order (customer_id);

-- Verify that the index exists.
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname = 'idx_customer_order_customer_id';