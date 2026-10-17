-- CloudMart Portfolio 5: Distributed & Cloud Database Simulation
-- Database: cloudmart_db (PostgreSQL 18)

-- Teardown existing objects for safe re-execution
DROP TABLE IF EXISTS orders_partitioned CASCADE;
DROP ROLE IF EXISTS cloudmart_replica_user;

-- 1. Simulate Primary-Replica Read-Only Connection / Replication Role Setup
CREATE ROLE cloudmart_replica_user WITH LOGIN PASSWORD 'ReplicaSecurePass2026!';
GRANT CONNECT ON DATABASE cloudmart_db TO cloudmart_replica_user;
GRANT USAGE ON SCHEMA public TO cloudmart_replica_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO cloudmart_replica_user;

-- 2. Simulate Horizontal Table Sharding / Range Partitioning Strategy for Orders
CREATE TABLE orders_partitioned (
    order_id SERIAL,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    region_id VARCHAR(10) NOT NULL, -- Sharding Key: 'US-EAST', 'EU-WEST', 'AF-WEST'
    total_amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY (order_id, region_id)
) PARTITION BY LIST (region_id);

-- Define Shard / Partition Tables representing distributed physical nodes
CREATE TABLE orders_shard_us PARTITION OF orders_partitioned FOR VALUES IN ('US-EAST');
CREATE TABLE orders_shard_eu PARTITION OF orders_partitioned FOR VALUES IN ('EU-WEST');
CREATE TABLE orders_shard_af PARTITION OF orders_partitioned FOR VALUES IN ('AF-WEST');

-- Insert Sample Workload routed automatically across distributed partitions
INSERT INTO orders_partitioned (customer_id, region_id, total_amount, status) VALUES
(1, 'AF-WEST', 150.00, 'COMPLETED'),
(2, 'US-EAST', 1299.99, 'PENDING'),
(3, 'EU-WEST', 89.99, 'SHIPPED'),
(4, 'AF-WEST', 249.50, 'COMPLETED');

-- 3. Verify Shard Routing Transparency (Queries execute against master interface)
SELECT 'AF-WEST Shard' AS shard, * FROM orders_shard_af;
SELECT 'US-EAST Shard' AS shard, * FROM orders_shard_us;
SELECT 'EU-WEST Shard' AS shard, * FROM orders_shard_eu;