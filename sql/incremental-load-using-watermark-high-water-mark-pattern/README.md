# SQL Daily Practice – Incremental Load Using Watermark (High-Water Mark Pattern)

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Incremental Loads, Watermark Pattern, Date Filtering, Performance-Aware Querying

---

## Problem Statement

You are building an incremental ETL pipeline.

Your source system continuously inserts new records into a transactional table.  
Instead of reloading the full table every time, you must load only new or updated records based on a **watermark timestamp**.

The watermark represents the last successfully processed `updated_ts`.

---

## Table Schema

### `source_orders`

```sql
CREATE TABLE source_orders (
    order_id     INT,
    customer_id  INT,
    order_amount DECIMAL(10,2),
    updated_ts   DATETIME
);
```
---

### `etl_watermark`
```sql
CREATE TABLE etl_watermark (
    pipeline_name VARCHAR(100),
    last_processed_ts DATETIME
);
```
---
## Sample Data

### `source_orders`

| order_id | customer_id | order_amount | updated_ts           |
|----------|------------:|--------------|----------------------|
| 101 | 1001 | 250.00 | 2024-10-01 09:00 |
| 102 | 1002 | 300.00 | 2024-10-01 10:00 |
| 103 | 1003 | 150.00 | 2024-10-01 11:00 |
| 104 | 1004 | 500.00 | 2024-10-01 12:00 |

---

### `etl_watermark`

| pipeline_name     | last_processed_ts     |
|------------------|-----------------------|
| orders_pipeline  | 2024-10-01 10:00 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to implement incremental load logic using a watermark.

The query must:

1. Dynamically fetch the last processed timestamp from `etl_watermark`.
2. Return only records from `source_orders` where: `updated_ts > last_processed_ts`
3. Assume `pipeline_name = 'orders_pipeline'`.
4. Do not hardcode the timestamp.
5. Use T-SQL–specific syntax.
6. Ensure deterministic ordering.
7. The query must be suitable for large production tables.

Return all columns from `source_orders`.

---

## Expected Output

| order_id | customer_id | order_amount | updated_ts           |
|----------|------------:|--------------|----------------------|
| 103 | 1003 | 150.00 | 2024-10-01 11:00 |
| 104 | 1004 | 500.00 | 2024-10-01 12:00 |

---

## Explanation

- Watermark = `2024-10-01 10:00`
- Records with:
- `updated_ts <= 10:00` → Already processed → Excluded
- `updated_ts > 10:00` → New/Updated → Included
- This pattern prevents full reloads and enables efficient incremental ETL.
