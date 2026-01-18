# SQL Daily Practice – Customer Order Gap Analysis

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Intermediate  
**Topic:** Window Functions, Date Calculations, Churn Analysis

---

## Problem Statement

You are working for a subscription-based e-commerce company.  
The business wants to analyze **time gaps between consecutive customer orders** to identify potential churn risk.

Each customer can place multiple orders over time.  
Your task is to calculate order-to-order gaps and flag large inactivity periods.

---

## Table Schema

### `orders`

```sql
CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    order_amount DECIMAL(10,2)
);
```
---
## Sample Data

```sql
INSERT INTO orders VALUES
(1, 101, '2024-01-01', 500.00),
(2, 101, '2024-01-05', 700.00),
(3, 101, '2024-02-20', 650.00),
(4, 102, '2024-01-03', 300.00),
(5, 102, '2024-01-10', 450.00),
(6, 103, '2024-01-15', 900.00);
```
---
## Business Requirements

For **each order**, derive the following fields:

1. `previous_order_date`  
   - The date of the customer’s immediately previous order

2. `days_since_last_order`  
   - Number of days between the current order date and the previous order date

3. `order_gap_flag`  
   - `'FIRST_ORDER'` if the order is the customer’s first order  
   - `'GAP_GT_30_DAYS'` if `days_since_last_order` is greater than 30  
   - `'NORMAL'` otherwise

### Additional Rules

- Orders must be evaluated **per customer**
- Orders should be processed in ascending order of `order_date`
- The first order for each customer must return `NULL` for both  
  `previous_order_date` and `days_since_last_order`
---
## Expected Output (Logical)

| order_id | customer_id | order_date | previous_order_date | days_since_last_order | order_gap_flag |
|--------:|------------:|-----------:|---------------------|-----------------------|----------------|
| 1 | 101 | 2024-01-01 | NULL | NULL | FIRST_ORDER |
| 2 | 101 | 2024-01-05 | 2024-01-01 | 4 | NORMAL |
| 3 | 101 | 2024-02-20 | 2024-01-05 | 46 | GAP_GT_30_DAYS |
| 4 | 102 | 2024-01-03 | NULL | NULL | FIRST_ORDER |
| 5 | 102 | 2024-01-10 | 2024-01-03 | 7 | NORMAL |
| 6 | 103 | 2024-01-15 | NULL | NULL | FIRST_ORDER |
