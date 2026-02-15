# SQL Daily Practice – Funnel Completion Validation (Event Sequencing)

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Event Sequencing, Funnel Analysis, Conditional Aggregation

---

## Problem Statement

You are analyzing product usage events to determine whether users successfully completed a defined conversion funnel.

The funnel consists of three ordered steps:

1. `VIEW_PRODUCT`
2. `ADD_TO_CART`
3. `PURCHASE`

A user is considered to have completed the funnel if:

- All three events occurred
- In the correct chronological order
- After the first `VIEW_PRODUCT`
- Without violating the required sequence

---

## Table Schema

### `user_events`

```sql
CREATE TABLE user_events (
    event_id    INT,
    user_id     INT,
    event_name  VARCHAR(50),
    event_ts    DATETIME
);
```
## Sample Data

### `user_events`

| event_id | user_id | event_name     | event_ts           |
|----------|--------:|----------------|-------------------|
| 1 | 2001 | VIEW_PRODUCT | 2024-05-01 10:00 |
| 2 | 2001 | ADD_TO_CART  | 2024-05-01 10:05 |
| 3 | 2001 | PURCHASE     | 2024-05-01 10:10 |
| 4 | 2002 | VIEW_PRODUCT | 2024-05-01 09:00 |
| 5 | 2002 | PURCHASE     | 2024-05-01 09:10 |
| 6 | 2003 | VIEW_PRODUCT | 2024-05-01 08:00 |
| 7 | 2003 | ADD_TO_CART  | 2024-05-01 08:05 |
| 8 | 2003 | VIEW_PRODUCT | 2024-05-01 08:20 |
| 9 | 2003 | PURCHASE     | 2024-05-01 08:30 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify users who successfully completed the conversion funnel:

1. `VIEW_PRODUCT`
2. `ADD_TO_CART`
3. `PURCHASE`

Conditions:

- Events must occur in the correct chronological order.
- All three events must exist.
- Events must occur after the first `VIEW_PRODUCT`.
- Users who skip a step do not qualify.
- If the event sequence is broken (e.g., a new `VIEW_PRODUCT` appears before `PURCHASE`), the user does not qualify.
- Return:
  - `user_id`
  - `first_view_ts`
  - `purchase_ts`
- Use T-SQL–specific syntax.
- Do not modify source data.
- Ensure deterministic ordering.

---

## Expected Output

| user_id | first_view_ts        | purchase_ts         |
|--------:|----------------------|---------------------|
| 2001 | 2024-05-01 10:00 | 2024-05-01 10:10 |

---

### Explanation

- **User 2001**  
  Completed all three events in correct order → qualifies.

- **User 2002**  
  Skipped `ADD_TO_CART` → does not qualify.

- **User 2003**  
  Performed a second `VIEW_PRODUCT` before completing the funnel → sequence invalid → does not qualify.
