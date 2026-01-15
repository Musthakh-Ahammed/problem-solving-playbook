
# Incremental Load with Deduplication (T-SQL)

## Problem Overview

You are working as a **Data Engineer** in an e-commerce company.  
Order events arrive multiple times per day from an upstream system and are stored in a **raw staging table**.  
These events may contain **duplicates** and **late-arriving updates**.

The goal is to incrementally load this data into a **fact table** such that it always reflects the **latest known state** of each order.

This problem focuses on **incremental loading, deduplication, and upsert logic** using Microsoft SQL Server (T-SQL).

---

## Table Schemas

### `stg_orders_raw`
Stores raw incoming order events.

```sql
CREATE TABLE stg_orders_raw (
    order_id        INT,
    customer_id     INT,
    order_status    VARCHAR(20),
    order_amount    DECIMAL(10,2),
    event_timestamp DATETIME,
    load_date       DATE
);
```

### `orders_fact`
Final deduplicated fact table.

```sql
CREATE TABLE orders_fact (
    order_id        INT PRIMARY KEY,
    customer_id     INT,
    order_status    VARCHAR(20),
    order_amount    DECIMAL(10,2),
    last_updated_at DATETIME
);
```

## Sample Data

### orders_fact (Before Incremental Load)

| order_id | customer_id | order_status | order_amount | last_updated_at       |
|--------:|------------:|-------------|-------------:|-----------------------|
| 101 | 1 | CONFIRMED | 500.00 | 2024-01-01 10:05:00 |

---

## Business Requirements

1. The `orders_fact` table must store **exactly one row per order**.
2. Each row must represent the **latest known state** of the order.
3. When new order events arrive:
   - If the `order_id` already exists, update the record **only if** the incoming event is **newer than `last_updated_at`**.
   - If the `order_id` does not exist, insert it as a new record.
4. Older or duplicate events **must not overwrite** newer data.
5. The table must support **idempotent loads**, meaning reprocessing the same data should not change the final result.

---

## Expected Output

### orders_fact (After Incremental Load)

| order_id | customer_id | order_status | order_amount | last_updated_at       |
|--------:|------------:|-------------|-------------:|-----------------------|
| 101 | 1 | SHIPPED   | 500.00 | 2024-01-02 08:10:00 |
| 102 | 2 | CANCELLED | 1200.00 | 2024-01-02 09:45:00 |
| 103 | 3 | CREATED   | 300.00 | 2024-01-02 14:20:00 |

---

## Notes

- The expected output reflects the **latest event per order** after processing incremental data.
- The table always maintains the **current state** of orders and does not store historical versions.
- Late-arriving records are handled by comparing timestamps before applying updates.
