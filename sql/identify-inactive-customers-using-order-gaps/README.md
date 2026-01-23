# Identify Inactive Customers Using Order Gaps

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Date Logic, Gap Detection

---

## Problem Statement

You are working with a customer order history table from a transactional system.  
Customers place orders at irregular intervals.

The business wants to identify **customers who became inactive**, defined as:

> A customer who has **not placed any order for 30 or more consecutive days** after a previous order.

This analysis is commonly used for **churn detection**, **customer segmentation**, and **re-engagement campaigns**.

---

## Table Schema

### `customer_orders`

```sql
CREATE TABLE customer_orders (
    customer_id   INT,
    order_id      INT,
    order_date    DATE,
    order_amount  DECIMAL(10,2)
);
```
---
## Sample Data

### `customer_orders`

| customer_id | order_id | order_date | order_amount |
|------------|----------|------------|--------------|
| 1 | 101 | 2024-01-01 | 250.00 |
| 1 | 102 | 2024-01-10 | 180.00 |
| 1 | 103 | 2024-02-20 | 300.00 |
| 2 | 201 | 2024-01-05 | 150.00 |
| 2 | 202 | 2024-01-25 | 200.00 |
| 3 | 301 | 2024-02-01 | 400.00 |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify customers who experienced **inactivity**, defined as a **gap of 30 days or more between two consecutive orders**.

The query must:

- Evaluate orders **per customer**
- Calculate the gap between **consecutive `order_date` values**
- Identify gaps of **30 days or more**
- Return the **order date before inactivity** and the **order date after inactivity**
- Ignore customers with **only one order**
- Use **T-SQL–specific syntax**
- Be **performance-aware**

---

## Expected Output

| customer_id | last_order_date | next_order_date | gap_in_days |
|------------|-----------------|-----------------|-------------|
| 1 | 2024-01-10 | 2024-02-20 | 41 |
