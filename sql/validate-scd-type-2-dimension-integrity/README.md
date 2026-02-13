# SQL Daily Practice – SCD Type 2 Integrity Validation

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Slowly Changing Dimensions (Type 2), Window Functions, Data Quality Validation, Date Logic

---

## Problem Statement

You are working with a **Slowly Changing Dimension (SCD Type 2)** table that tracks historical changes to customer attributes.

Each time a customer attribute changes, a new record is inserted with:

- `effective_start_date`
- `effective_end_date`
- `is_current` flag

The business wants to identify **data integrity violations** in the dimension table.

---

## Table Schema

### `dim_customer`

```sql
CREATE TABLE dim_customer (
    customer_sk           INT,
    customer_id           INT,
    city                  VARCHAR(100),
    effective_start_date  DATE,
    effective_end_date    DATE,
    is_current            BIT
);
```
---
## Sample Data

### `dim_customer`

| customer_sk | customer_id | city       | effective_start_date | effective_end_date | is_current |
|------------:|------------:|------------|----------------------|-------------------|------------|
| 1 | 1101 | Mumbai     | 2024-01-01 | 2024-03-31 | 0 |
| 2 | 1101 | Delhi      | 2024-04-01 | NULL       | 1 |
| 3 | 1102 | Chennai    | 2024-01-01 | NULL       | 1 |
| 4 | 1102 | Bangalore  | 2024-02-01 | NULL       | 1 |
| 5 | 1103 | Pune       | 2024-01-01 | 2024-02-28 | 0 |
| 6 | 1103 | Pune       | 2024-02-15 | NULL       | 1 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify **SCD Type 2 integrity violations** in the `dim_customer` table.

A violation occurs if:

1. A customer has **more than one record with `is_current = 1`**
   - Violation type: `MULTIPLE_CURRENT`

2. A customer has **overlapping effective date ranges**
   - Violation type: `OVERLAP`

3. The previous record’s `effective_end_date` does not equal  
   `effective_start_date - 1`
   - Violation type: `DATE_GAP`

Rules:

- Evaluate violations **per `customer_id`**
- Treat `NULL effective_end_date` as active
- Back-to-back records must strictly follow:
