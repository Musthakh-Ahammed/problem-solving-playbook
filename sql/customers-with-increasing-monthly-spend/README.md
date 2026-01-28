# Customers with Increasing Monthly Spend

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Aggregation, Window Functions, Date Logic, Trend Detection

---

## Problem Statement

You are working with a **customer payments table** that records individual payment transactions.

The business wants to identify **high-growth customers**, defined as customers whose **total monthly spending is strictly increasing for at least three consecutive months**.

This analysis is commonly used for **customer growth tracking**, **retention analysis**, and **lifecycle segmentation**.

---

## Table Schema

### `customer_payments`

```sql
CREATE TABLE customer_payments (
    payment_id   INT,
    customer_id  INT,
    payment_date DATE,
    amount       DECIMAL(10,2)
);
```
---
## Sample Data

### `customer_payments`

| payment_id | customer_id | payment_date | amount |
|-----------|------------|--------------|--------|
| 1 | 201 | 2024-01-05 | 200.00 |
| 2 | 201 | 2024-01-20 | 300.00 |
| 3 | 201 | 2024-02-10 | 600.00 |
| 4 | 201 | 2024-03-15 | 800.00 |
| 5 | 202 | 2024-01-10 | 500.00 |
| 6 | 202 | 2024-02-05 | 400.00 |
| 7 | 202 | 2024-03-01 | 600.00 |
| 8 | 203 | 2024-01-08 | 100.00 |
| 9 | 203 | 2024-02-12 | 200.00 |
| 10 | 203 | 2024-03-18 | 300.00 |

---
