# SQL Daily Practice – Customers With Increasing Monthly Spend Trend

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topics:** Window Functions, Time-Series Analysis, Trend Detection

---

## Problem Statement

You work for an **e-commerce platform**.  
The business wants to identify customers whose **monthly spending shows a consistent upward trend**, as these customers are strong candidates for loyalty programs and upsell campaigns.

Your task is to detect customers whose **total monthly spend increases month-over-month for at least three consecutive months**.

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
| 1 | 301 | 2024-01-05 | 100 |
| 2 | 301 | 2024-02-10 | 150 |
| 3 | 301 | 2024-03-15 | 200 |
| 4 | 301 | 2024-04-20 | 180 |
| 5 | 302 | 2024-01-07 | 50 |
| 6 | 302 | 2024-02-08 | 80 |
| 7 | 302 | 2024-03-09 | 120 |
| 8 | 303 | 2024-01-12 | 200 |
| 9 | 303 | 2024-03-14 | 220 |
| 10 | 304 | 2024-01-05 | 90 |
| 11 | 304 | 2024-02-06 | 110 |
| 12 | 304 | 2024-03-07 | 130 |
| 13 | 304 | 2024-04-08 | 150 |

---
