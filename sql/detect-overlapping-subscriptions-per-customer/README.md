# Detect Overlapping Subscriptions per Customer

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Date Range Logic, Self Joins, NULL Handling, Data Quality Checks

---

## Problem Statement

You are working with a **subscription management system** where customers can have multiple subscriptions over time.

Due to upgrades, downgrades, or system issues, some customers may end up with **overlapping active subscriptions**, which should normally not occur.

The business wants to **identify all subscriptions that are part of an overlap** so they can audit and correct the data.

---

## Table Schema

### `customer_subscriptions`

```sql
CREATE TABLE customer_subscriptions (
    subscription_id INT,
    customer_id     INT,
    plan_name       VARCHAR(50),
    start_date      DATE,
    end_date        DATE -- NULL indicates an active subscription
);
```

## Sample Data

### `customer_subscriptions`

| subscription_id | customer_id | plan_name | start_date | end_date   |
|-----------------|-------------|-----------|------------|------------|
| 1 | 801 | Basic   | 2024-01-01 | 2024-03-31 |
| 2 | 801 | Premium | 2024-03-15 | 2024-06-30 |
| 3 | 802 | Basic   | 2024-02-01 | 2024-02-28 |
| 4 | 803 | Basic   | 2024-01-10 | NULL |
| 5 | 803 | Pro     | 2024-02-01 | 2024-04-01 |
| 6 | 804 | Basic   | 2024-01-01 | 2024-01-31 |
| 7 | 804 | Basic   | 2024-02-01 | 2024-02-28 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify **overlapping subscriptions per customer**.

The query must:

- Evaluate subscriptions **per customer**
- Treat `NULL` `end_date` as **active until today** (`GETDATE()`)
- Identify **true overlaps** where subscription date ranges intersect
- **Exclude back-to-back subscriptions**  
  (i.e., `end_date = next start_date` is NOT an overlap)
- Return **all subscriptions that are part of an overlap**
- Ensure each overlapping subscription appears **only once**
- Use **T-SQL–specific syntax**
- Not modify the source data

---

## Expected Output

| customer_id | subscription_id | plan_name | start_date | end_date   |
|------------|-----------------|-----------|------------|------------|
| 801 | 1 | Basic   | 2024-01-01 | 2024-03-31 |
| 801 | 2 | Premium | 2024-03-15 | 2024-06-30 |
| 803 | 4 | Basic   | 2024-01-10 | NULL |
| 803 | 5 | Pro     | 2024-02-01 | 2024-04-01 |

