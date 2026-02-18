# SQL Daily Practice – Latest Order Version for Incremental Load

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
