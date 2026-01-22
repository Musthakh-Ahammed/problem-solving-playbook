# Rolling 7-Day Active Users (DAU-7)

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topic:** Rolling Metrics, Date Spine, Distinct Counts

---

## Problem Statement

You work for a SaaS product company that tracks user activity at the event level.  
The analytics team wants to report **rolling 7-day active users (DAU-7)** to measure user engagement and growth.

A user is considered **active on a day** if they generate **at least one event** on that day.

Your task is to calculate daily rolling 7-day active users, ensuring correct handling of:
- Duplicate events per user per day
- Days with no activity
- Date-based rolling windows (not row-based)

---

## Table Schema

### `user_events`

```sql
CREATE TABLE user_events (
    user_id    INT,
    event_time DATETIME
);
```
---
## Sample Data

```sql
INSERT INTO user_events VALUES
(1, '2024-01-01 09:00:00'),
(1, '2024-01-01 18:00:00'),
(2, '2024-01-01 10:00:00'),
(1, '2024-01-03 11:00:00'),
(3, '2024-01-03 12:00:00'),
(2, '2024-01-04 14:00:00'),
(4, '2024-01-05 16:00:00'),
(1, '2024-01-07 09:30:00'),
(2, '2024-01-07 10:00:00'),
(3, '2024-01-08 11:00:00');
```
---
## Business Requirements

For **each calendar date** between the earliest and latest event dates, calculate:

1. `activity_date`  
   - A continuous calendar date (including days with no activity)

2. `rolling_7_day_active_users`  
   - The count of **distinct users** who were active in the **current date and the previous 6 days** (7-day rolling window)

### Rules

- A user is considered **active on a day** if they generate **at least one event** on that day
- Each user must be counted **only once per day**
- Days with **no user activity must still appear** in the output
- The rolling window must be **date-based**, not row-based
- The solution must work correctly for **large datasets**
---
## Expected Output (Logical)

| activity_date | rolling_7_day_active_users |
|---------------|----------------------------|
| 2024-01-01 | 2 |
| 2024-01-02 | 2 |
| 2024-01-03 | 3 |
| 2024-01-04 | 3 |
| 2024-01-05 | 4 |
| 2024-01-06 | 4 |
| 2024-01-07 | 4 |
| 2024-01-08 | 4 |
