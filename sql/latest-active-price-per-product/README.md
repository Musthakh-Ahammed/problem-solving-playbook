# SQL Daily Practice 
## Latest Active Price Per Product (Effective Dating)

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** INTERMEDIATE  

---

## Problem Statement

You work for a retail company that maintains historical product prices.  
Prices change over time, and each change is stored as a new record with an effective date.

The business needs to generate a report that shows the **latest active price per product** as of a given date.

---

## Table Schema  
`product_price_history`

```sql
CREATE TABLE product_price_history (
    product_id      INT,
    price           DECIMAL(10,2),
    effective_date  DATE
);
```
---
## Sample Data
```sql
INSERT INTO product_price_history VALUES
(1, 100.00, '2024-01-01'),
(1, 120.00, '2024-02-01'),
(1, 130.00, '2024-03-15'),
(2, 200.00, '2024-01-10'),
(2, 220.00, '2024-02-20'),
(3, 150.00, '2024-03-01');
```
---
## Business Requirement

Given an **as-of date** `'2024-02-28'`, return:

- `product_id`
- `price` → the most recent price effective **on or before** the as-of date
- `effective_date` → the effective date of that price

---
### Rules
- If a product has multiple price changes, select the latest valid one
- If a product has no price effective on or before the as-of date, exclude it
- The query must work correctly for any as-of date

## Expected Output (Logical)

| product_id | price  | effective_date |
|-----------:|-------:|:--------------|
| 1          | 120.00 | 2024-02-01     |
| 2          | 220.00 | 2024-02-20     |

*(Product 3 is excluded because its price becomes effective after the as-of date.)*

