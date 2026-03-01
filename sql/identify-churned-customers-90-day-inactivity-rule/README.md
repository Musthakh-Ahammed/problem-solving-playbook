# Identify Churned Customers (90-Day Inactivity Rule)

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Date Logic, Aggregation, Window Functions, Customer Lifecycle Analytics

---

## Problem Statement

The business defines a customer as **churned** if they have not placed any order in the last **90 days**.

You need to identify:

- Customers who are currently churned
- The last order date
- Number of days since last order

Assume today's date is dynamically evaluated using `GETDATE()`.

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
