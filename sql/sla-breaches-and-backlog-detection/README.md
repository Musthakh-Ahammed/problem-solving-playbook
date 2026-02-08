# SQL Daily Practice — SLA Breaches & Backlog Detection

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topics:** Window Functions, Date Arithmetic, Event Modeling, Gaps & Islands

---

## Problem Overview

You work for an **e-commerce fulfillment platform** where every order is expected to be shipped within a defined **Service Level Agreement (SLA)**.

The business wants to:
1. Identify **orders that violate the SLA**
2. Detect **continuous backlog periods** where overdue orders accumulate and are not fully cleared

This problem focuses on **system-level state modeling**, not just order-level analysis.

---

## Table Schemas

### `orders`

```sql
CREATE TABLE orders (
    order_id     INT,
    customer_id  INT,
    order_date   DATE
);
```

### `shipments`
```sql
CREATE TABLE shipments (
    shipment_id  INT,
    order_id     INT,
    shipped_date DATE
);
```
---

## Business Definitions

### SLA Deadline
- Each order must be shipped within **3 calendar days** from the `order_date`.
- `sla_deadline = order_date + 3 days`

### SLA Status (Order Level)
- **ON_TIME**  
  Shipped on or before the SLA deadline.
- **BREACHED**  
  Shipped after the SLA deadline.
- **PENDING**  
  Not shipped and already past the SLA deadline.

### Backlog (System Level)
- A **backlog** is a **continuous time period** where **at least one order is overdue and unshipped**.
- A backlog:
  - **Starts** when the first overdue, unshipped order appears.
  - **Ends** only when **all overdue orders are shipped**.
  - Has a `NULL` end date if it is **still active**.
- Backlog is **system-level**, not order-level.

---

## Sample Data

### Orders

| order_id | customer_id | order_date |
|---------:|------------:|-----------:|
| 1 | 501 | 2024-01-01 |
| 2 | 502 | 2024-01-02 |
| 3 | 503 | 2024-01-03 |
| 4 | 504 | 2024-01-05 |
| 5 | 505 | 2024-01-06 |

### Shipments

| shipment_id | order_id | shipped_date |
|------------:|---------:|-------------:|
| 101 | 1 | 2024-01-02 |
| 102 | 2 | 2024-01-07 |
| 103 | 3 | 2024-01-10 |
| 104 | 4 | 2024-01-06 |
| — | 5 | NULL |

---

## Business Requirements

### Part 1 — SLA Analysis
For each order:
1. Calculate the SLA deadline (`order_date + 3 days`)
2. Determine the SLA status:
   - ON_TIME
   - BREACHED
   - PENDING
3. Include orders that are breached or pending in the analysis.

### Part 2 — Backlog Detection
1. Identify **continuous backlog periods** at the system level.
2. A backlog exists on a day if **at least one order is overdue and unshipped**.
3. Backlog periods must:
   - Start when overdue order count goes from `0 → >0`
   - End when overdue order count goes from `>0 → 0`
4. Count the **distinct orders** that were overdue at any point during the backlog period.
5. If the backlog has not cleared, the end date must be `NULL`.

---

## Expected Output

### Part 1 — SLA Status

| order_id | order_date | shipped_date | sla_deadline | sla_status |
|--------:|-----------:|-------------:|-------------:|-----------|
| 2 | 2024-01-02 | 2024-01-07 | 2024-01-05 | BREACHED |
| 3 | 2024-01-03 | 2024-01-10 | 2024-01-06 | BREACHED |
| 5 | 2024-01-06 | NULL | 2024-01-09 | PENDING |

---

### Part 2 — Backlog Periods

| backlog_start_date | backlog_end_date | total_orders_in_backlog |
|-------------------|------------------|------------------------|
| 2024-01-06 | NULL | 3 |

---

### Notes
- Orders **2, 3, and 5** contribute to the backlog.
- There is **no day** where overdue orders drop to zero.
- Therefore, the backlog is **still active**.


