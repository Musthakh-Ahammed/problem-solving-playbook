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
