# SQL Daily Practice – Reconstruct Current Inventory from Event Log

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
