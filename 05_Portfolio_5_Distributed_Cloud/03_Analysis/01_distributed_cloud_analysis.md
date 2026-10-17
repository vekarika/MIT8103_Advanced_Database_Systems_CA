# CloudMart Portfolio 5: Distributed & Cloud Database Technical Analysis

## 1. Architecture & Fragmentation Strategy
The CloudMart E-Commerce Platform uses **Horizontal Data Fragmentation (Sharding)** to distribute high-volume order workloads across regional database nodes[cite: 9].
- **Sharding Key:** `region_id` ('US-EAST', 'EU-WEST', 'AF-WEST')[cite: 9].
- **Implementation Mechanism:** List-based range partitioning (`PARTITION BY LIST (region_id)`), creating distinct physical shard tables (`orders_shard_us`, `orders_shard_eu`, `orders_shard_af`)[cite: 9].
- **Transparency:** The application layer writes directly to `orders_partitioned` without needing location-awareness; the engine routes transactions transparently[cite: 9].

## 2. Replication & High Availability (HA)
To eliminate single points of failure and scale read throughput:
- **Primary-Replica Topology:** A single Primary node processes write transactions (`INSERT`, `UPDATE`, `DELETE`) and streams Write-Ahead Logs (WAL) asynchronously to geographically dispersed Read Replicas[cite: 9].
- **Role Provisioning:** Dedicated read-only replica accounts (`cloudmart_replica_user`) offload heavy reporting and customer order history queries from the primary node[cite: 9].

## 3. Theoretical Framework: CAP Theorem & Consistency Models

| Feature / Model | Transactional Core (PostgreSQL) | Product Catalog (MongoDB) |
| :--- | :--- | :--- |
| **CAP Classification** | **CP / CA** (Strict Consistency & Partition Tolerance)[cite: 9] | **CP / AP** (Tunable Consistency & High Availability)[cite: 9] |
| **Transaction Model** | **ACID** (Atomicity, Consistency, Isolation, Durability)[cite: 9] | **BASE** (Basically Available, Soft-state, Eventual consistency)[cite: 9] |
| **Replication Mode** | Synchronous WAL for primary; Asynchronous for replicas[cite: 9] | Replica Set with Raft consensus[cite: 9] |
| **Primary Use Case** | Order processing, payments, inventory deductions[cite: 9] | Product catalog, recommendations, user reviews[cite: 9] |

## 4. Cloud Infrastructure & Managed Services Deployment
In production, CloudMart adopts a **Multi-Cloud DBaaS (Database-as-a-Service)** topology[cite: 9]:
1. **AWS RDS PostgreSQL (Multi-AZ):** Hosts the transactional database with automated failover, point-in-time recovery (PITR), and cross-region read replicas[cite: 9].
2. **MongoDB Atlas:** Serves the distributed product document store with auto-sharding and automatic cluster scaling[cite: 9].