# CloudMart Portfolio 5: Distributed and Cloud Database Analysis

## 1. Objective

This portfolio demonstrates regional data partitioning in PostgreSQL and evaluates how partitioning, replication, and cloud database services can support the CloudMart e-commerce platform.

The implementation is a local simulation of selected distributed-database concepts. It is not a deployment of a fully distributed database cluster.

## 2. Regional Data Partitioning

The demonstration uses a partitioned table named `orders_partitioned`, partitioned by LIST on `region_id`.

Three partitions were created:

- `orders_shard_af`: AF-WEST
- `orders_shard_eu`: EU-WEST
- `orders_shard_us`: US-EAST

Four sample orders were inserted through the parent table. PostgreSQL routed the records to the appropriate partitions.

### Execution results

| Region | Order count | Total order value |
|---|---:|---:|
| AF-WEST | 2 | 399.50 |
| EU-WEST | 1 | 89.99 |
| US-EAST | 1 | 1,299.99 |
| **Total** | **4** | **1,789.48** |

The results from the parent table and individual partitions agreed.

### Partition pruning

The query plan for a query filtering on `region_id = 'AF-WEST'` showed:

`Seq Scan on orders_shard_af orders_partitioned`

This demonstrates that PostgreSQL selected the relevant partition rather than scanning all three partitions.

The sequential scan is reasonable for this small demonstration dataset. The experiment does not establish a measurable performance improvement because it does not compare execution times against an equivalent unpartitioned dataset.

**Implementation limitation:** These partitions are tables managed by one PostgreSQL database instance. They are not independent regional database servers. This implementation demonstrates partitioning, not distributed physical sharding.

## 3. Read-Only Access and Replication Concepts

The implementation creates or reuses the PostgreSQL role `cloudmart_replica_user` and grants database connection, schema usage, and table-reading privileges.

This demonstrates role-based access for a reporting user. The script does not configure the role as a physical replication account, and it does not create or connect to a standby server.

A production primary-replica design would require separate PostgreSQL instances, replication configuration, appropriate authentication and replication permissions, monitoring, and a tested failover procedure. Depending on the required recovery objectives, replication could be synchronous or asynchronous.

A read-only database role and a physical standby replica are different components and should not be treated as interchangeable.

## 4. CAP Theorem and Consistency Considerations

The CAP theorem describes trade-offs that arise when a distributed system experiences a network partition. During such a partition, a system cannot simultaneously guarantee both linearizable consistency and availability for every request.

CAP is not a simple permanent label that classifies PostgreSQL as one category and MongoDB as another. The practical behavior depends on the deployment architecture, replication configuration, consistency settings, and failure conditions.

For CloudMart:

- Orders, payments, and inventory require carefully controlled transactional updates and integrity constraints.
- Product catalog documents can benefit from a flexible schema when product categories have different attributes.
- Replication and failover settings should be selected according to consistency requirements, acceptable downtime, and recovery objectives.
- Eventual consistency may be acceptable for some catalog or analytical reads, but should not be assumed appropriate for every operation.

The Portfolio 4 MongoDB implementation demonstrates document modeling and indexing. It does not, by itself, demonstrate a distributed MongoDB cluster or establish a particular CAP behavior.

## 5. Proposed Production Cloud Architecture

A production implementation could use managed database services to reduce routine infrastructure administration.

### Transactional database

A managed PostgreSQL service could host customers, orders, payments, and inventory. The deployment should define backup retention, point-in-time recovery, high-availability configuration, monitoring, access controls, and recovery objectives.

Read replicas could support suitable read-heavy workloads. Their use would require explicit consideration of replication lag and the consistency needs of each query.

### Product catalog

MongoDB Atlas or another managed document database could host flexible product documents, category-specific attributes, tags, and ratings. Indexes should be selected based on measured query patterns and validated with execution plans.

### Regional distribution

If CloudMart needs independent regional database nodes, the architecture would require a genuine distributed deployment or an application-managed sharding design. The team would need to define shard-key selection, cross-region routing, data ownership, failure handling, and cross-shard transaction requirements.

The local PostgreSQL partitions in this portfolio are a foundation for discussing regional data organization, not a substitute for that production architecture.

## 6. Conclusion

The successful SQL execution verified automatic routing of four sample orders into three regional partitions and demonstrated partition pruning for an AF-WEST query. The read-only role setup illustrates database access control.

The practical implementation does not configure physical replication, independent database nodes, automatic failover, or a cloud deployment. Those capabilities remain proposed production enhancements and would require separate implementation and testing.