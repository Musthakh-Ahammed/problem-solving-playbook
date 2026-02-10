# SQL Daily Practice – Latest Record per Customer (Incremental Load)

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
