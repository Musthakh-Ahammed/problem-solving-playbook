# Customer Reactivation After Inactivity

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topics:** Window Functions, Customer Lifecycle Analysis, Date Logic

---

## Problem Statement

You work for a **subscription-based digital product** company.  
The business wants to identify customers who **became inactive for a significant period and then returned**, in order to analyze reactivation behavior and campaign effectiveness.

Your task is to detect **reactivation events** where a customer was inactive for **at least 60 consecutive days** before placing a new order.

---

## Table Schema

### `orders`

```sql
CREATE TABLE orders (
    order_id     INT,
    customer_id  INT,
    order_date   DATE,
    order_amount DECIMAL(10,2)
);
```
---
## Sample Data

| order_id | customer_id | order_date | order_amount |
|---------:|------------:|-----------:|-------------:|
| 1 | 401 | 2024-01-05 | 120 |
| 2 | 401 | 2024-01-20 | 150 |
| 3 | 401 | 2024-04-01 | 180 |
| 4 | 402 | 2024-01-10 | 200 |
| 5 | 402 | 2024-02-15 | 220 |
| 6 | 402 | 2024-03-10 | 240 |
| 7 | 403 | 2024-01-01 | 100 |
| 8 | 403 | 2024-05-05 | 130 |
| 9 | 404 | 2024-02-01 | 90 |
| 10 | 404 | 2024-02-20 | 110 |
| 11 | 404 | 2024-04-25 | 140 |

---
## Business Requirements

The business wants to identify **customers who became inactive for a prolonged period and later returned**, in order to analyze reactivation behavior and campaign effectiveness.

A customer is considered **reactivated** if **all** of the following conditions are met:

1. There is a gap of **at least 60 consecutive days** between two **consecutive orders**
2. The inactivity period is **continuous** (no orders in between)
3. The customer places a **new order after the inactivity period**
4. The **first order** of a customer cannot be a reactivation
5. A customer may have **multiple reactivation events**

---

## Expected Output

The output should contain **one row per reactivation event**.

### Output Columns

- `customer_id`  
- `last_active_date`  
  - Date of the order **before the inactivity period**
- `reactivation_date`  
  - Date of the **first order after inactivity**
- `inactive_days`  
  - Number of days the customer was inactive

---

### Expected Output (Based on Sample Data)

| customer_id | last_active_date | reactivation_date | inactive_days |
|------------:|-----------------:|------------------:|--------------:|
| 401 | 2024-01-20 | 2024-04-01 | 72 |
| 403 | 2024-01-01 | 2024-05-05 | 125 |
| 404 | 2024-02-20 | 2024-04-25 | 65 |

---

### Notes

- Customer **402** does not appear in the output because there is no inactivity period of 60 days or more
- Inactivity is measured strictly between **consecutive orders**
- Missing days imply inactivity; no calendar table is required
- The solution must be **event-based**, not aggregation-based
