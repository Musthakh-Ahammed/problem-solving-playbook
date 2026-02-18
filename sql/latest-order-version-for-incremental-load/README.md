# Latest Order Version for Incremental Load

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Deduplication, Window Functions, Incremental ETL, Deterministic Tie-Breaking

---

## Problem Statement

You are building an incremental ETL pipeline to load order data from a staging table into a fact table.

The staging table may contain:

- Multiple versions of the same `order_id`
- Status updates
- Amount corrections
- Late-arriving changes
- Multiple batches

Your task is to identify the **latest version of each order** for processing.

---

## Table Schema

### `stg_orders`

```sql
CREATE TABLE stg_orders (
    batch_id     INT,
    order_id     INT,
    customer_id  INT,
    order_status VARCHAR(50),
    order_amount DECIMAL(10,2),
    updated_ts   DATETIME
);
```
---
## Sample Data

### `stg_orders`

| batch_id | order_id | customer_id | order_status | order_amount | updated_ts           |
|----------|---------:|------------:|--------------|--------------|---------------------|
| 1 | 5001 | 9001 | CREATED   | 100.00 | 2024-07-01 09:00 |
| 1 | 5001 | 9001 | SHIPPED   | 100.00 | 2024-07-01 10:00 |
| 1 | 5002 | 9002 | CREATED   | 200.00 | 2024-07-01 09:30 |
| 2 | 5001 | 9001 | DELIVERED | 100.00 | 2024-07-02 08:00 |
| 2 | 5002 | 9002 | CANCELLED | 200.00 | 2024-07-02 09:00 |
| 2 | 5003 | 9003 | CREATED   | 150.00 | 2024-07-02 09:15 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify the **latest version of each order** from the staging table.

Rules:

- A single `order_id` may appear multiple times.
- The latest version is determined by:
  1. Highest `updated_ts`
  2. If timestamps are equal, highest `batch_id`
- Return exactly one row per `order_id`.
- Return the following columns:
  - `order_id`
  - `customer_id`
  - `order_status`
  - `order_amount`
  - `updated_ts`
- Use T-SQL–specific syntax.
- Do not modify the source data.
- The result must be deterministic and suitable for incremental ETL processing.

---

## Expected Output

| order_id | customer_id | order_status | order_amount | updated_ts |
|----------|------------:|--------------|--------------|------------|
| 5001 | 9001 | DELIVERED | 100.00 | 2024-07-02 08:00 |
| 5002 | 9002 | CANCELLED | 200.00 | 2024-07-02 09:00 |
| 5003 | 9003 | CREATED   | 150.00 | 2024-07-02 09:15 |

---

### Explanation

- **Order 5001** → Multiple updates → Latest is `DELIVERED`.
- **Order 5002** → Updated to `CANCELLED` → Latest wins.
- **Order 5003** → Only appears once → Returned as-is.
