# Orders Placed After a Price Drop

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Point-in-Time Joins, Price Change Detection

---

## Problem Statement

You are working with **product price history** and **order data**.

The business wants to identify **customers who placed an order immediately after a product’s price dropped**.  
This helps measure **price sensitivity**, **promotion effectiveness**, and **customer behavior**.

---

## Table Schemas

### `product_price_history`

```sql
CREATE TABLE product_price_history (
    product_id   INT,
    price        DECIMAL(10,2),
    effective_dt DATE
);
```
### `orders`
```sql
CREATE TABLE orders (
    order_id     INT,
    customer_id  INT,
    product_id   INT,
    order_date   DATE
```
---
## Sample Data

### `product_price_history`

| product_id | price | effective_dt |
|------------|-------|--------------|
| 501 | 1000 | 2024-01-01 |
| 501 | 900  | 2024-02-01 |
| 501 | 850  | 2024-03-01 |
| 502 | 500  | 2024-01-10 |
| 502 | 500  | 2024-02-15 |
| 502 | 450  | 2024-03-10 |

---

### `orders`

| order_id | customer_id | product_id | order_date |
|----------|-------------|------------|------------|
| 1 | 401 | 501 | 2024-02-02 |
| 2 | 402 | 501 | 2024-01-20 |
| 3 | 403 | 501 | 2024-03-05 |
| 4 | 404 | 502 | 2024-03-12 |
| 5 | 405 | 502 | 2024-02-20 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify **orders placed after a product price drop**.

The query must:

- Evaluate **price history per product**
- Detect **true price drops** (current price < previous price)
- Match each order to the **price effective at the time of order**
- Return only orders where the order occurred **after a price reduction**
- Ignore orders placed when the price was unchanged or increased
- Use **T-SQL–specific syntax**
- Not modify the source data
- Be **performance-aware**

---

## Expected Output

| customer_id | product_id | order_id | order_date | new_price |
|-------------|------------|----------|------------|-----------|
| 401 | 501 | 1 | 2024-02-02 | 900 |
| 403 | 501 | 3 | 2024-03-05 | 850 |
| 404 | 502 | 4 | 2024-03-12 | 450 |

