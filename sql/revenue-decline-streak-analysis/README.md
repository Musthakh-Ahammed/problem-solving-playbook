# Revenue Decline Streak Analysis

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topic:** Window Functions, Islands & Gaps, Time-Series Analysis

---

## Problem Statement

You work for a **subscription-based SaaS company**.  
The finance team wants to proactively identify **continuous revenue decline streaks** for each product to detect early signs of churn or product risk.

Daily revenue is already aggregated at the product level.

Your task is to detect **consecutive periods of revenue decline** and compute meaningful streak-level metrics.

---

## Table Schema

### `daily_product_revenue`

```sql
CREATE TABLE daily_product_revenue (
    product_id     INT,
    revenue_date   DATE,
    revenue_amount DECIMAL(10,2)
);
```
---
## Sample Data

| product_id | revenue_date | revenue_amount |
|-----------:|-------------:|---------------:|
| 1 | 2024-01-01 | 1000 |
| 1 | 2024-01-02 | 950 |
| 1 | 2024-01-03 | 900 |
| 1 | 2024-01-04 | 920 |
| 1 | 2024-01-05 | 880 |
| 1 | 2024-01-06 | 850 |
| 2 | 2024-01-01 | 500 |
| 2 | 2024-01-02 | 520 |
| 2 | 2024-01-03 | 510 |
| 2 | 2024-01-04 | 505 |
| 2 | 2024-01-05 | 540 |

---
## Business Requirements

For each product, identify **revenue decline streaks**, where a streak is defined as a sequence of days that meet **all** of the following conditions:

- Revenue **strictly decreases** compared to the previous day  
- Days are **calendar-consecutive** (no missing dates)
- The streak **ends** when:
  - Revenue increases
  - Revenue stays the same
  - A date gap occurs

For each valid decline streak, compute:

1. `product_id`  
2. `streak_id`  
   - Sequential identifier per product
3. `streak_start_date`  
   - First day when revenue starts declining
4. `streak_end_date`  
   - Last day of consecutive decline
5. `streak_length_days`  
   - Number of consecutive days with revenue decline
6. `total_revenue_drop`  
   - Total revenue lost during the streak

### Rules

- Ignore single-day declines (minimum streak length = **2 days**)
- Flat revenue (`no change`) **breaks** a streak
- Logic must be **date-based**, not row-based
- Calculations must reflect **actual business revenue loss**

---

## Expected Output (Logical)

| product_id | streak_id | streak_start_date | streak_end_date | streak_length_days | total_revenue_drop |
|-----------:|----------:|-------------------|-----------------|--------------------|--------------------|
| 1 | 1 | 2024-01-02 | 2024-01-03 | 2 | 100 |
| 1 | 2 | 2024-01-05 | 2024-01-06 | 2 | 30 |
| 2 | 1 | 2024-01-03 | 2024-01-04 | 2 | 15 |
