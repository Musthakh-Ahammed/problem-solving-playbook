# Detect Price Changes for Products

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Change Detection, Event Sequencing

---

## Problem Statement

You are working with a **product pricing history table** where each record represents a product price that was effective from a given date.

Products may have multiple records where the **price does not change**.  
The business wants to identify **only the points in time when a product’s price actually changed**.

This type of logic is commonly used in **pricing analytics**, **audit reporting**, and **slowly changing dimensions (SCD)**.

---

## Table Schema

### `product_price_history`

```sql
CREATE TABLE product_price_history (
    product_id   INT,
    price        DECIMAL(10,2),
    effective_dt DATE
);
```
---
## Sample Data

### `product_price_history`

| product_id | price | effective_dt |
|-----------|-------|--------------|
| 101 | 500.00 | 2024-01-01 |
| 101 | 500.00 | 2024-01-10 |
| 101 | 550.00 | 2024-02-01 |
| 101 | 600.00 | 2024-03-01 |
| 102 | 300.00 | 2024-01-05 |
| 102 | 300.00 | 2024-02-01 |
| 102 | 320.00 | 2024-03-10 |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify **only the points in time when a product’s price actually changed**.

The query must:

- Evaluate price history **per product**
- Compare each price with the **previous price** using `effective_dt` ordering
- Ignore consecutive records where the price **remains the same**
- Return the **previous price**, **new price**, and the **date of change**
- Use **T-SQL–specific syntax**
- Be **performance-aware**
- Not modify the source data

---

## Expected Output

| product_id | old_price | new_price | change_date |
|-----------|-----------|-----------|-------------|
| 101 | 500.00 | 550.00 | 2024-02-01 |
| 101 | 550.00 | 600.00 | 2024-03-01 |
| 102 | 300.00 | 320.00 | 2024-03-10 |
