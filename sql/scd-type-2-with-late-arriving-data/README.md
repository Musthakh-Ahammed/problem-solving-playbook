# SCD Type 2 with Late-Arriving Data

**Role:** Senior Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topic:** Slowly Changing Dimension (Type 2), Late-Arriving Data, Temporal Modeling

---

## Problem Statement

You are maintaining a **Customer Dimension (SCD Type 2)** in a data warehouse.

Customer attribute updates arrive from a source system, but:
- Updates can arrive **out of order** (late-arriving data)
- A customer can have **multiple changes on the same day**
- Historical values must be **fully preserved**

The goal is to correctly apply SCD Type-2 logic while maintaining **accurate, non-overlapping historical records**.

---

## Table Schemas

### `stg_customer_updates` (Incoming Updates)

```sql
CREATE TABLE stg_customer_updates (
    customer_id    INT,
    customer_name  VARCHAR(100),
    city           VARCHAR(50),
    update_ts      DATETIME
);
```
---
### `dim_customer` (SCD Type 2 Dimension)
```sql
CREATE TABLE dim_customer (
    customer_sk    INT IDENTITY(1,1) PRIMARY KEY,
    customer_id    INT,
    customer_name  VARCHAR(100),
    city           VARCHAR(50),
    effective_from DATETIME,
    effective_to   DATETIME,
    is_current     BIT
);
```
---
## Sample Data

### Existing `dim_customer`

| customer_sk | customer_id | customer_name | city      | effective_from | effective_to | is_current |
|------------:|------------:|---------------|-----------|----------------|--------------|------------|
| 1 | 101 | John Smith | New York | 2024-01-01 00:00:00 | 9999-12-31 00:00:00 | 1 |
| 2 | 102 | Alice Lee  | Chicago  | 2024-01-05 00:00:00 | 9999-12-31 00:00:00 | 1 |

```sql
INSERT INTO dim_customer
(customer_id, customer_name, city, effective_from, effective_to, is_current)
VALUES
(101, 'John Smith', 'New York', '2024-01-01 00:00:00', '9999-12-31 00:00:00', 1),
(102, 'Alice Lee',  'Chicago',  '2024-01-05 00:00:00', '9999-12-31 00:00:00', 1);
```
---
### Incoming `stg_customer_updates`

| customer_id | customer_name | city    | update_ts           |
| ----------: | ------------- | ------- | ------------------- |
|         101 | John Smith    | Boston  | 2024-01-20 10:00:00 |
|         101 | John Smith    | Seattle | 2024-01-18 09:00:00 |
|         102 | Alice Lee     | Chicago | 2024-01-25 14:00:00 |
|         103 | Mark Davis    | Austin  | 2024-01-22 11:00:00 |

```sql
INSERT INTO stg_customer_updates
(customer_id, customer_name, city, update_ts)
VALUES
(101, 'John Smith', 'Boston',  '2024-01-20 10:00:00'),
(101, 'John Smith', 'Seattle', '2024-01-18 09:00:00'),
(102, 'Alice Lee',  'Chicago', '2024-01-25 14:00:00'),
(103, 'Mark Davis', 'Austin',  '2024-01-22 11:00:00');
```
