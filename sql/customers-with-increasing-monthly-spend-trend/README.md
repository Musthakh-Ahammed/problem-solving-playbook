# Customers With Increasing Monthly Spend Trend

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
## Business Requirements

The business wants to identify **high-value customers** whose spending shows a **consistent upward trend** over time.

A customer qualifies if **all** of the following conditions are met:

1. Monthly spend is calculated as:
   - `SUM(order_amount)` per `customer_id` per calendar month
2. Monthly spend must **strictly increase** compared to the previous month
3. The increase must occur for **at least 3 consecutive months**
4. Months must be **calendar-consecutive**
   - Missing months **break** the trend
5. Flat or decreasing spend **breaks** the trend

> **Important:**  
> Three consecutive increases require **four months of data**.

---

## Expected Output

The output should include only customers who meet the trend criteria.

### Output Columns

- `customer_id`
- `trend_start_month`  
  - The first month where an increase occurs
- `trend_end_month`  
  - The last month in the increasing trend
- `consecutive_increases`  
  - Number of consecutive month-over-month increases

---

### Expected Output (Based on Sample Data)

| customer_id | trend_start_month | trend_end_month | consecutive_increases |
|------------:|------------------:|----------------:|----------------------:|
| 304 | 2024-02-01 | 2024-04-01 | 3 |

---

### Explanation

- Customer **304**:
  - Jan → Feb ↑  
  - Feb → Mar ↑  
  - Mar → Apr ↑  
  - **3 consecutive increases → qualifies**

- Customer **301**:
  - Only 2 consecutive increases → **does not qualify**

- Customer **302**:
  - Only 2 months of growth → **does not qualify**

- Customer **303**:
  - Missing February → trend **breaks**

---

### Key Notes

- The trend start month corresponds to the **first increase**, not the baseline month
- Calendar gaps invalidate trends
- Trend detection is **event-based**, not calendar-filled
