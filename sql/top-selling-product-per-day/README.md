# Top-Selling Product per Day

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Aggregations, Window Functions, Ranking

---

## Problem Statement

You are working with a **sales transactions table** from an e-commerce platform.  
Each record represents a product sold as part of an order.

The business wants to analyze **daily sales performance** by identifying the **top-selling product for each day**, based on **total revenue**.

---

## Table Schema

### `sales_transactions`

```sql
CREATE TABLE sales_transactions (
    order_id     INT,
    product_id   INT,
    order_date   DATE,
    quantity     INT,
    unit_price   DECIMAL(10,2)
);
```
---
## Sample Data

### `sales_transactions`

| order_id | product_id | order_date | quantity | unit_price |
|---------|------------|------------|----------|------------|
| 1 | 10 | 2024-01-01 | 2 | 500.00 |
| 2 | 20 | 2024-01-01 | 1 | 800.00 |
| 3 | 10 | 2024-01-01 | 1 | 500.00 |
| 4 | 30 | 2024-01-02 | 3 | 200.00 |
| 5 | 20 | 2024-01-02 | 2 | 800.00 |
| 6 | 10 | 2024-01-02 | 1 | 500.00 |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify the **top-selling product for each day** based on **total revenue**.

The query must:

- Calculate **revenue** as `quantity × unit_price`
- Aggregate revenue **per product per day**
- Rank products **within each day** by total revenue
- Return only the **highest-revenue product per day**
- Use **T-SQL–specific syntax**
- Not modify the source data
- Be **performance-aware**

---

## Expected Output

| order_date | product_id | total_revenue |
|-----------|------------|---------------|
| 2024-01-01 | 10 | 1500.00 |
| 2024-01-02 | 20 | 1600.00 |
