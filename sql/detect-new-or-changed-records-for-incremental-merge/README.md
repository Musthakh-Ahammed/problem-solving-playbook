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
