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
## Sample Data

### `customer_orders`

| order_id | customer_id | order_date  | order_amount |
|----------|------------:|------------|--------------|
| 1 | 1001 | 2024-06-01 | 200.00 |
| 2 | 1001 | 2024-07-01 | 150.00 |
| 3 | 1002 | 2024-03-01 | 300.00 |
| 4 | 1003 | 2024-08-15 | 400.00 |
| 5 | 1004 | 2024-01-10 | 100.00 |

Assume today's date is dynamically evaluated using: `GETDATE()`

## Business Requirement

Write a T-SQL query (Microsoft SQL Server) to identify churned customers.
A customer is considered churned if:`DATEDIFF(DAY, last_order_date, GETDATE()) > 90`

**The query must return:**
- customer_id
- last_order_date
- days_since_last_order

**Rules:**
- Calculate the last order date dynamically per customer.
- Use `GETDATE()` — do not hardcode today's date.
- Only return customers who are churned.
- Use T-SQL–specific syntax.
- Ensure deterministic ordering.

### Expected Output

(Assuming `GETDATE()` = '2024-10-01')

| customer_id | last_order_date | days_since_last_order |
| ----------: | --------------- | --------------------- |
|        1001 | 2024-07-01      | 92                    |
|        1002 | 2024-03-01      | 214                   |
|        1004 | 2024-01-10      | 265                   |



### Explanation

Customer 1001 → Last order 2024-07-01 → 92 days ago → Churned (>90).
Customer 1002 → Last order 2024-03-01 → 214 days ago → Churned.
Customer 1003 → Last order 2024-08-15 → 47 days ago → Active (Excluded).
Customer 1004 → Last order 2024-01-10 → 265 days ago → Churned.
