# SQL Daily Practice – Customer Reactivation After Inactivity

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
