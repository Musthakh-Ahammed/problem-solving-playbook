# Latest Record per Customer (Incremental Load)

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Deduplication, Window Functions, Incremental Loads, Deterministic Ordering

---

## Problem Statement

You are working on an **incremental data pipeline** that ingests customer profile updates into a staging table.

Due to retries, late-arriving data, and multiple updates within the same batch, the same customer may appear **multiple times** with different update timestamps.

The business requirement is to keep **only the latest version of each customer record**.

This is a very common pattern in **data engineering**, especially for:
- Incremental ETL pipelines
- CDC (Change Data Capture)
- Slowly Changing Dimensions (Type 1)

---

## Table Schema

### `customer_profile_staging`

```sql
CREATE TABLE customer_profile_staging (
    batch_id       INT,
    customer_id    INT,
    customer_name  VARCHAR(100),
    email          VARCHAR(100),
    updated_ts     DATETIME
);
```
---
## Sample Data

### `customer_profile_staging`

| batch_id | customer_id | customer_name | email               | updated_ts         |
|----------|-------------|---------------|---------------------|--------------------|
| 101 | 901 | John Doe  | john@mail.com       | 2024-04-01 10:00 |
| 101 | 901 | John Doe  | john.d@mail.com     | 2024-04-01 12:30 |
| 101 | 902 | Alice     | alice@mail.com      | 2024-04-01 09:00 |
| 101 | 903 | Mark      | mark@mail.com       | 2024-04-01 11:00 |
| 102 | 901 | John D.   | john.new@mail.com   | 2024-04-02 08:00 |
| 102 | 903 | Mark      | mark@mail.com       | 2024-04-02 07:30 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify the **latest customer profile record per customer_id** from a staging table used in an incremental load.

The query must:

- Handle **multiple records per customer**
- Select the **most recent update** based on `updated_ts`
- Use `batch_id` as a **tie-breaker** when timestamps are equal
- Return **exactly one record per customer**
- Be **deterministic**
- Use **T-SQL–specific syntax**
- Not modify the source data

---

## Expected Output

| customer_id | customer_name | email               | updated_ts         |
|-------------|---------------|---------------------|--------------------|
| 901 | John D. | john.new@mail.com | 2024-04-02 08:00 |
| 902 | Alice   | alice@mail.com    | 2024-04-01 09:00 |
| 903 | Mark    | mark@mail.com     | 2024-04-02 07:30 |
