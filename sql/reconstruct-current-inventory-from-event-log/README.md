# Reconstruct Current Inventory from Event Log

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Conditional Aggregation, Event Sourcing, State Reconstruction

---

## Problem Statement

You are working with an event-based inventory system.

Instead of storing the current stock level directly, the system logs inventory changes as events:

- `STOCK_IN` → Adds quantity
- `STOCK_OUT` → Removes quantity

Your task is to reconstruct the **current inventory level per product** using the event log.

This reflects a real-world **event-sourcing pattern** commonly used in distributed systems.

---

## Table Schema

### `inventory_events`

```sql
CREATE TABLE inventory_events (
    event_id     INT,
    product_id   INT,
    event_type   VARCHAR(20),  -- 'STOCK_IN' or 'STOCK_OUT'
    quantity     INT,
    event_ts     DATETIME
);
```
---
## Sample Data

### `inventory_events`

| event_id | product_id | event_type | quantity | event_ts           |
|----------|-----------:|------------|---------:|-------------------|
| 1 | 3001 | STOCK_IN  | 100 | 2024-06-01 09:00 |
| 2 | 3001 | STOCK_OUT | 30  | 2024-06-02 10:00 |
| 3 | 3001 | STOCK_IN  | 20  | 2024-06-03 11:00 |
| 4 | 3002 | STOCK_IN  | 50  | 2024-06-01 08:00 |
| 5 | 3002 | STOCK_OUT | 10  | 2024-06-04 12:00 |
| 6 | 3003 | STOCK_OUT | 5   | 2024-06-05 14:00 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to compute the **current inventory level per product** using an event-based inventory table.

Rules:

- `STOCK_IN` increases inventory.
- `STOCK_OUT` decreases inventory.
- Inventory can become negative.
- Return:
  - `product_id`
  - `current_stock`
- Use **T-SQL–specific syntax**.
- Do **not** modify source data.
- Ensure deterministic results.

---

## Expected Output

| product_id | current_stock |
|------------|---------------|
| 3001 | 90 |
| 3002 | 40 |
| 3003 | -5 |

---

### Explanation

- **Product 3001**  
  100 − 30 + 20 = 90

- **Product 3002**  
  50 − 10 = 40

- **Product 3003**  
  0 − 5 = -5

