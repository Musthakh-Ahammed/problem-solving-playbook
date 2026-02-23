# SQL Daily Practice – Detect New or Changed Records for Incremental Merge

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Change Detection, Incremental ETL, NULL Handling, Joins

---

## Problem Statement

You maintain a `fact_orders` table in your data warehouse.

Each day, new data arrives in `stg_orders`.

Your task is to detect:

1. **New records** – Orders that exist in staging but not in fact.
2. **Changed records** – Orders that exist in both tables but have differences in business columns.

Only these records should be passed to a downstream `MERGE` process.

---

## Table Schema

### `fact_orders`

```sql
CREATE TABLE fact_orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    order_status VARCHAR(50),
    order_amount DECIMAL(10,2),
    updated_ts   DATETIME
);
```
---
### `stg_orders`
```sql
CREATE TABLE stg_orders (
    order_id     INT,
    customer_id  INT,
    order_status VARCHAR(50),
    order_amount DECIMAL(10,2),
    updated_ts   DATETIME
);
```
---
## Sample Data

### `fact_orders`

| order_id | customer_id | order_status | order_amount | updated_ts |
|----------|------------:|--------------|--------------|------------|
| 8001 | 9101 | SHIPPED   | 100.00 | 2024-09-01 |
| 8002 | 9102 | CREATED   | 200.00 | 2024-09-01 |
| 8003 | 9103 | DELIVERED | 150.00 | 2024-09-01 |

---

### `stg_orders`

| order_id | customer_id | order_status | order_amount | updated_ts |
|----------|------------:|--------------|--------------|------------|
| 8001 | 9101 | DELIVERED | 100.00 | 2024-09-02 |
| 8002 | 9102 | CREATED   | 200.00 | 2024-09-01 |
| 8004 | 9104 | CREATED   | 300.00 | 2024-09-02 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to detect records in `stg_orders` that need to be processed in an incremental load.

The query must return:

1. **New orders**  
   - Orders that exist in `stg_orders` but do not exist in `fact_orders`.

2. **Changed orders**  
   - Orders that exist in both tables but have differences in any of the following columns:
     - `customer_id`
     - `order_status`
     - `order_amount`

Additional rules:

- Do **not** rely only on `updated_ts` to detect changes.
- Handle NULL comparisons correctly.
- Return all columns from `stg_orders`.
- Use T-SQL–specific syntax.
- The result must be deterministic.
- Suitable for incremental ETL / MERGE preparation.

---

## Expected Output

| order_id | customer_id | order_status | order_amount | updated_ts |
|----------|------------:|--------------|--------------|------------|
| 8001 | 9101 | DELIVERED | 100.00 | 2024-09-02 |
| 8004 | 9104 | CREATED   | 300.00 | 2024-09-02 |

---

### Explanation

- **8001** → Status changed (`SHIPPED` → `DELIVERED`) → Included.
- **8002** → No changes → Excluded.
- **8004** → Does not exist in `fact_orders` → New record → Included.
