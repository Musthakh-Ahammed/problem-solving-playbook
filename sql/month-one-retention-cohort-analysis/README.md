# SQL Daily Practice – Month 1 Retention (Cohort Analysis)

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Cohort Analysis, Date Logic, Conditional Aggregation, Retention Metrics

---

## Problem Statement

You are analyzing user engagement for a SaaS product.

The business wants to calculate **Month 1 retention**:

> For users who signed up in a given month, how many returned and performed at least one activity in the following calendar month?

---

## Table Schema

### `users`

```sql
CREATE TABLE users (
    user_id     INT,
    signup_date DATE
);
```
---
### `user_activity`
```sql
CREATE TABLE user_activity (
    activity_id INT,
    user_id     INT,
    activity_dt DATE
);
```
---
## Sample Data

### `users`

| user_id | signup_date |
|--------:|------------|
| 6001 | 2024-01-10 |
| 6002 | 2024-01-15 |
| 6003 | 2024-02-05 |
| 6004 | 2024-02-20 |

---

### `user_activity`

| activity_id | user_id | activity_dt |
|------------:|--------:|------------|
| 1 | 6001 | 2024-02-03 |
| 2 | 6001 | 2024-03-01 |
| 3 | 6002 | 2024-01-20 |
| 4 | 6003 | 2024-03-10 |
| 5 | 6004 | 2024-03-15 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to calculate **Month 1 retention**.

Rules:

- Cohort month is defined as: `DATETRUNC(MONTH, signup_date)`
- A user is considered **retained** if they perform at least one activity in: `signup_month + 1 calendar month`
- Count each user only once (multiple activities should not inflate retention).
- Return:
- `cohort_month`
- `total_users`
- `retained_users`
- `retention_rate` (retained_users / total_users)
- Use T-SQL–specific syntax.
- Do not modify source data.
- The result must be deterministic.

---

## Expected Output

| cohort_month | total_users | retained_users | retention_rate |
|--------------|------------|----------------|----------------|
| 2024-01-01 | 2 | 1 | 0.50 |
| 2024-02-01 | 2 | 2 | 1.00 |

---

### Explanation

**January 2024 Cohort**
- Users: 6001, 6002
- 6001 had activity in February → retained
- 6002 did not → not retained
- Retention = 1 / 2 = 0.50

**February 2024 Cohort**
- Users: 6003, 6004
- Both had activity in March → retained
- Retention = 2 / 2 = 1.00
