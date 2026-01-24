# First Purchase per Product per Customer

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Deduplication, Grouping

---

## Problem Statement

You are working with an **e-commerce order items table**.  
Customers can purchase the **same product multiple times** over different dates.

The business wants to identify **when each customer first purchased each product** in order to analyze acquisition and buying behavior.

---

## Table Schema

### `order_items`

```sql
CREATE TABLE order_items (
    order_id     INT,
    customer_id  INT,
    product_id   INT,
    order_date   DATE,
    quantity     INT,
    unit_price   DECIMAL(10,2)
);
```
---
## Sample Data

### `order_items`

| order_id | customer_id | product_id | order_date | quantity | unit_price |
|---------|-------------|------------|------------|----------|------------|
| 1 | 101 | 10 | 2024-01-01 | 1 | 500.00 |
| 2 | 101 | 10 | 2024-02-15 | 2 | 500.00 |
| 3 | 101 | 20 | 2024-01-10 | 1 | 300.00 |
| 4 | 102 | 10 | 2024-01-05 | 1 | 500.00 |
| 5 | 102 | 20 | 2024-03-01 | 3 | 300.00 |
| 6 | 103 | 10 | 2024-02-01 | 1 | 500.00 |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify the **first purchase of each product for every customer**.

The query must:

- Evaluate purchases **per customer and per product**
- Identify the **earliest purchase date** for each `(customer_id, product_id)` combination
- Return the corresponding **order ID** for that first purchase
- Handle cases where customers purchase the same product multiple times
- Use **T-SQL–specific syntax**
- Be **performance-aware**
- Not modify the source data

---

## Expected Output

| customer_id | product_id | first_purchase_date | first_order_id |
|------------|-----------|---------------------|----------------|
| 101 | 10 | 2024-01-01 | 1 |
| 101 | 20 | 2024-01-10 | 3 |
| 102 | 10 | 2024-01-05 | 4 |
| 102 | 20 | 2024-03-01 | 5 |
| 103 | 10 | 2024-02-01 | 6 |
