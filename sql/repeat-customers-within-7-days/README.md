# Identify Repeat Customers Within 7 Days

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Date Logic, Sequential Analysis

---

## Problem Statement

You are working with a **customer orders table** from an online ordering system.  
Customers can place multiple orders over time.

The business wants to identify **repeat customers**, defined as customers who place another order **within 7 days of their previous order**.  
This metric is used to measure **short-term customer engagement**.

---

## Table Schema

### `customer_orders`

```sql
CREATE TABLE customer_orders (
    order_id     INT,
    customer_id  INT,
    order_date   DATE,
    order_amount DECIMAL(10,2)
);
```
---
## Sample Data

### `customer_orders`

| order_id | customer_id | order_date | order_amount |
|---------|-------------|------------|--------------|
| 1 | 101 | 2024-01-01 | 500.00 |
| 2 | 101 | 2024-01-05 | 300.00 |
| 3 | 101 | 2024-01-20 | 700.00 |
| 4 | 102 | 2024-01-03 | 400.00 |
| 5 | 102 | 2024-01-12 | 600.00 |
| 6 | 103 | 2024-01-10 | 200.00 |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify **repeat customers**, defined as customers who placed a **consecutive order within 7 days** of their previous order.

The query must:

- Evaluate orders **per customer**
- Compare **consecutive order dates**
- Calculate the number of days between orders using `order_date`
- Identify cases where the gap is **7 days or less**
- Ignore customers with **only one order**
- Use **T-SQL–specific syntax**
- Be **performance-aware**

---

## Expected Output

| customer_id | previous_order_date | repeat_order_date | days_between_orders |
|------------|---------------------|-------------------|---------------------|
| 101 | 2024-01-01 | 2024-01-05 | 4 |
