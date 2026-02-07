# Latest Non-Cancelled Shipment per Order

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Deduplication, Conditional Filtering

---

## Problem Statement

You are working with a **shipment events table** where each order may have **multiple shipment attempts** due to cancellations, re-shipments, or operational issues.

The business wants to identify the **latest valid shipment for each order**, excluding cancelled shipments.

This is a common requirement in **logistics, fulfillment systems, and operational reporting**.

---

## Table Schema

### `order_shipments`

```sql
CREATE TABLE order_shipments (
    shipment_id   INT,
    order_id      INT,
    shipment_ts   DATETIME,
    status        VARCHAR(20) -- 'CREATED', 'SHIPPED', 'CANCELLED'
);
```
## Sample Data

### `order_shipments`

| shipment_id | order_id | shipment_ts        | status     |
|-------------|----------|--------------------|------------|
| 1 | 701 | 2024-01-01 10:00 | CREATED |
| 2 | 701 | 2024-01-02 09:00 | CANCELLED |
| 3 | 701 | 2024-01-03 08:30 | SHIPPED |
| 4 | 702 | 2024-01-05 11:00 | CREATED |
| 5 | 702 | 2024-01-06 10:00 | CANCELLED |
| 6 | 703 | 2024-01-07 14:00 | SHIPPED |
| 7 | 704 | 2024-01-08 09:00 | CANCELLED |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to determine the **latest valid shipment for each order**.

The query must:

- Evaluate shipment events **per order**
- Treat any shipment with `status = 'CANCELLED'` as **invalid**
- Return **only the most recent non-cancelled shipment** per order
- Exclude orders that have **no valid shipments**
- Use **T-SQL–specific syntax**
- Not modify the source data
- Be **performance-aware**

---

## Expected Output

| order_id | shipment_id | shipment_ts        | status   |
|----------|-------------|--------------------|----------|
| 701 | 3 | 2024-01-03 08:30 | SHIPPED |
| 703 | 6 | 2024-01-07 14:00 | SHIPPED |
