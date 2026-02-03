# Detect Consecutive Login Streaks

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Date Logic, Streak Detection

---

## Problem Statement

You are working with a **user activity tracking system** where each record represents a day a user logged into an application.

The business wants to identify **highly engaged users**, defined as users who logged in for **at least 3 consecutive calendar days**.

This analysis is commonly used for **user engagement**, **retention tracking**, and **behavioral analytics**.

---

## Table Schema

### `user_logins`

```sql
CREATE TABLE user_logins (
    user_id     INT,
    login_date  DATE
);
```
---
## Sample Data

### `user_logins`

| user_id | login_date |
|--------|------------|
| 1 | 2024-01-01 |
| 1 | 2024-01-02 |
| 1 | 2024-01-03 |
| 1 | 2024-01-05 |
| 2 | 2024-01-01 |
| 2 | 2024-01-03 |
| 2 | 2024-01-04 |
| 3 | 2024-01-10 |
| 3 | 2024-01-11 |
| 3 | 2024-01-12 |
| 3 | 2024-01-13 |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify users who logged in for **at least three consecutive calendar days**.

The query must:

- Evaluate login activity **per user**
- Detect **consecutive login days** with no gaps
- Identify login streaks of **three days or more**
- Return:
  - `user_id`
  - `start_date` — first day of the login streak
  - `end_date` — last day of the login streak
- Use **T-SQL–specific syntax**
- Not modify the source data

---

## Expected Output

| user_id | start_date | end_date |
|--------|------------|----------|
| 1 | 2024-01-01 | 2024-01-03 |
| 3 | 2024-01-10 | 2024-01-13 |
