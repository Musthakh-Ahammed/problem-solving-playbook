
# SQL Daily Practice – Sessionization Using T-SQL

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Intermediate  
**Topic:** Sessionization, Window Functions, Time-Based Aggregation

---

## Problem Statement

You are working with website clickstream data where users generate multiple events over time.  
A **session** is defined as a continuous sequence of events for a user where the time gap between consecutive events is **30 minutes or less**.

If the gap between two consecutive events is **greater than 30 minutes**, a **new session** begins.

Your task is to identify sessions and compute session-level metrics.

---

## Table Schema

### `web_events`

```sql
CREATE TABLE web_events (
    user_id     INT,
    event_time  DATETIME,
    event_type  VARCHAR(50)
);
```
---

### Sample Data

```sql
INSERT INTO web_events VALUES
(1, '2024-01-10 09:00:00', 'page_view'),
(1, '2024-01-10 09:10:00', 'click'),
(1, '2024-01-10 10:00:00', 'page_view'),
(1, '2024-01-10 10:20:00', 'click'),
(1, '2024-01-10 12:00:00', 'page_view'),
(2, '2024-01-10 08:00:00', 'page_view'),
(2, '2024-01-10 08:20:00', 'click'),
(2, '2024-01-10 09:00:00', 'page_view');
```
---

## Business Requirements

For **each user and each session**, compute the following:

1. `session_id`  
   - A sequential number per user starting from **1**
2. `session_start_time`  
   - Earliest event time in the session
3. `session_end_time`  
   - Latest event time in the session
4. `total_events_in_session`  
   - Total number of events in the session

### Session Rules

- Events must be ordered by `event_time`
- Sessions are calculated **independently per user**
- If the time difference between two consecutive events is **30 minutes or less**, they belong to the same session
- If the time difference is **greater than 30 minutes**, a **new session** starts

---

## Expected Output (Logical)

| user_id | session_id | session_start_time | session_end_time | total_events |
|--------:|-----------:|--------------------|------------------|--------------|
| 1 | 1 | 2024-01-10 09:00:00 | 2024-01-10 09:10:00 | 2 |
| 1 | 2 | 2024-01-10 10:00:00 | 2024-01-10 10:20:00 | 2 |
| 1 | 3 | 2024-01-10 12:00:00 | 2024-01-10 12:00:00 | 1 |
| 2 | 1 | 2024-01-10 08:00:00 | 2024-01-10 08:20:00 | 2 |
| 2 | 2 | 2024-01-10 09:00:00 | 2024-01-10 09:00:00 | 1 |
