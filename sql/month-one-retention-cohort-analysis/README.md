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
