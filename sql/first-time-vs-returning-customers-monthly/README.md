# First-Time vs Returning Customers (Monthly)

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topic:** Customer Lifecycle Analysis, Window Functions, Aggregations

---

## Problem Statement

You work for an **e-commerce platform** and the business wants to analyze **customer acquisition vs retention trends** over time.

Using order-level data, your task is to classify customers **per month** as either:
- **First-Time Customers** (placing their first-ever order)
- **Returning Customers** (customers who have ordered previously)

The analysis is performed at a **monthly grain**.

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
| 1 | 101 | 2024-01-05 | 200 |
| 2 | 102 | 2024-01-10 | 150 |
| 3 | 101 | 2024-02-02 | 300 |
| 4 | 103 | 2024-02-15 | 120 |
| 5 | 102 | 2024-02-20 | 180 |
| 6 | 101 | 2024-03-01 | 250 |
| 7 | 104 | 2024-03-10 | 100 |

---
## Business Requirements

For **each calendar month**, analyze customer ordering behavior and calculate:

1. `order_month`  
   - Month in which orders were placed

2. `first_time_customers`  
   - Number of customers placing their **first-ever order** in that month

3. `returning_customers`  
   - Number of customers who have **placed at least one order before** that month

4. `total_customers`  
   - Total distinct customers who placed **at least one order** in that month

### Rules & Assumptions

- A customer is classified as **first-time only once** (in their first order month)
- All subsequent months for that customer are classified as **returning**
- Customers are counted **once per month**, regardless of how many orders they place
- Classification is based on **customer history**, not order volume
- The dataset is assumed to contain **complete historical data**
- Analysis is performed at the **monthly grain** (order date within the month is not required)

---

## Expected Output (Logical)

| order_month | first_time_customers | returning_customers | total_customers |
|------------:|---------------------:|--------------------:|----------------:|
| 2024-01 | 2 | 0 | 2 |
| 2024-02 | 1 | 2 | 3 |
| 2024-03 | 1 | 1 | 2 |
