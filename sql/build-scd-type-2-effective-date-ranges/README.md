# SQL Daily Practice – Build SCD Type 2 Effective Date Ranges

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Change Detection, Date Logic, Slowly Changing Dimensions (SCD2)

---

## Problem Statement

You receive daily snapshots of customer attributes in a staging table.

Your task is to transform this snapshot data into a **Slowly Changing Dimension Type 2 (SCD2)** structure by generating:

- `effective_start_date`
- `effective_end_date`
- `is_current` flag

A new dimension version should only be created when the tracked attribute (`city`) changes.

---

## Table Schema

### `stg_customer_attributes`

```sql
CREATE TABLE stg_customer_attributes (
    customer_id   INT,
    customer_name VARCHAR(100),
    city          VARCHAR(100),
    snapshot_dt   DATE
);
```
---
## Sample Data

### `stg_customer_attributes`

| customer_id | customer_name | city      | snapshot_dt |
|------------:|--------------|-----------|-------------|
| 9001 | John  | New York | 2024-01-01 |
| 9001 | John  | Boston   | 2024-02-01 |
| 9001 | John  | Boston   | 2024-03-01 |
| 9001 | John  | Chicago  | 2024-04-01 |
| 9002 | Alice | Dallas   | 2024-01-01 |
| 9002 | Alice | Dallas   | 2024-02-01 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to generate a Slowly Changing Dimension Type 2 (SCD2) output from the snapshot data.

The query must return:

- `customer_id`
- `customer_name`
- `city`
- `effective_start_date`
- `effective_end_date`
- `is_current`

Rules:

1. A new version should be created **only when `city` changes**.
2. Consecutive duplicate cities should not create new records.
3. `effective_start_date` = `snapshot_dt` of the first occurrence of that version.
4. `effective_end_date` = one day before the next version starts.
5. The latest record must have:
   - `effective_end_date = NULL`
   - `is_current = 1`
6. Use T-SQL–specific syntax.
7. Do not modify source data.
8. Ensure deterministic ordering.

---

## Expected Output

### Customer 9001

| customer_id | customer_name | city      | effective_start_date | effective_end_date | is_current |
|-------------|--------------|-----------|----------------------|--------------------|------------|
| 9001 | John | New York | 2024-01-01 | 2024-01-31 | 0 |
| 9001 | John | Boston   | 2024-02-01 | 2024-03-31 | 0 |
| 9001 | John | Chicago  | 2024-04-01 | NULL       | 1 |

---

### Customer 9002

| customer_id | customer_name | city   | effective_start_date | effective_end_date | is_current |
|-------------|--------------|--------|----------------------|--------------------|------------|
| 9002 | Alice | Dallas | 2024-01-01 | NULL | 1 |

---

### Explanation

**Customer 9001**
- City changed from New York → Boston → Chicago.
- Duplicate Boston snapshot (March) does not create a new version.
- Effective dates are adjusted accordingly.
- Latest version (Chicago) is marked as current.

**Customer 9002**
- City never changed.
- Only one SCD record is created.
- Marked as current.
