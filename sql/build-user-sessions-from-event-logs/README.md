# Build User Sessions from Event Logs

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Gaps & Islands, Date Logic, Sessionization

---

## Problem Statement

You are given a stream of timestamped user events.

The business defines a **session** as:

> A sequence of user events where the gap between consecutive events is **30 minutes or less**.

If the time gap between two events is **greater than 30 minutes**, a new session begins.

Your task is to reconstruct sessions from raw event data.

---

## Table Schema

### `user_events`

```sql
CREATE TABLE user_events (
    event_id   INT,
    user_id    INT,
    event_ts   DATETIME
);
```
---
## Sample Data

### `user_events`

| event_id | user_id | event_ts           |
|----------|---------|--------------------|
| 1 | 1001 | 2024-10-01 09:00 |
| 2 | 1001 | 2024-10-01 09:10 |
| 3 | 1001 | 2024-10-01 09:40 |
| 4 | 1001 | 2024-10-01 11:00 |
| 5 | 1001 | 2024-10-01 11:20 |
| 6 | 1002 | 2024-10-01 08:00 |
| 7 | 1002 | 2024-10-01 08:50 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to reconstruct user sessions from raw event logs.

Session Definition:

- A session is a sequence of events where the gap between consecutive events is **30 minutes or less**.
- If `DATEDIFF(MINUTE, previous_event_ts, current_event_ts) > 30`, a new session begins.
- The first event per user starts a new session.

The query must return:

- `user_id`
- `session_id` (sequential per user, starting from 1)
- `session_start_ts`
- `session_end_ts`
- `event_count`

Additional Rules:

- Events must be ordered by `event_ts`.
- Use T-SQL–specific syntax.
- Do not modify source data.
- The result must be deterministic.

---

## Expected Output

### For `user_id = 1001`

| user_id | session_id | session_start_ts     | session_end_ts       | event_count |
|----------|------------|---------------------|----------------------|-------------|
| 1001 | 1 | 2024-10-01 09:00 | 2024-10-01 09:40 | 3 |
| 1001 | 2 | 2024-10-01 11:00 | 2024-10-01 11:20 | 2 |

---

### For `user_id = 1002`

| user_id | session_id | session_start_ts     | session_end_ts       | event_count |
|----------|------------|---------------------|----------------------|-------------|
| 1002 | 1 | 2024-10-01 08:00 | 2024-10-01 08:00 | 1 |
| 1002 | 2 | 2024-10-01 08:50 | 2024-10-01 08:50 | 1 |

---

### Explanation

**User 1001**
- Events at 09:00, 09:10, 09:40 → gaps ≤ 30 minutes → same session.
- Gap between 09:40 and 11:00 > 30 minutes → new session.
- Events at 11:00, 11:20 → same session.

**User 1002**
- 08:00 → first session.
- Gap between 08:00 and 08:50 > 30 minutes → new session.
