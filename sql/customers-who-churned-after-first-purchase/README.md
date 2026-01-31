# Customers Who Churned After First Purchase

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topic:** Customer Churn Analysis, Window Functions

---

## Problem Statement

You work for a **subscription-based e-commerce platform**.  
The business wants to identify customers who **made exactly one purchase and never returned**, so they can be targeted with re-engagement campaigns.

Your task is to detect customers who **churned immediately after their first purchase**.

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
---
## Sample Data

| order_id | customer_id | order_date | order_amount |
|---------:|------------:|-----------:|-------------:|
| 1 | 201 | 2024-01-05 | 120 |
| 2 | 202 | 2024-01-06 | 200 |
| 3 | 201 | 2024-02-10 | 180 |
| 4 | 203 | 2024-02-12 | 150 |
| 5 | 204 | 2024-02-15 | 300 |
| 6 | 202 | 2024-03-01 | 220 |
| 7 | 205 | 2024-03-05 | 100 |

---
## Business Requirements

The goal is to identify customers who **churned immediately after their first purchase**.

A customer is considered **churned** if all of the following conditions are met:

1. The customer has **exactly one order** in the dataset  
2. The customer **never placed a second order** after their first purchase  
3. The dataset is assumed to contain the customer’s **complete order history**

For each churned customer, return:

- `customer_id`  
- `first_order_month`  
  - Month of the customer’s only purchase (`YYYY-MM` format)
- `first_order_amount`  
  - Order amount of the customer’s only purchase

### Rules & Assumptions

- Customers with more than one order must be excluded
- Since the customer has only one order:
  - That order is both the **first and last**
- Customers are evaluated independently
- Logic must be **row-based**, not dependent on accidental aggregation
- Monthly formatting is for reporting only

---

## Expected Output (Logical)

| customer_id | first_order_month | first_order_amount |
|------------:|------------------:|-------------------:|
| 203 | 2024-02 | 150 |
| 204 | 2024-02 | 300 |
| 205 | 2024-03 | 100 |
