# Consecutive Revenue Decline Detection

**Role:** Data Engineer  
**Database:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Advanced  
**Topics Covered:** Window Functions, Time-Series Analysis, Streak Detection, Date Continuity Validation

---

## Problem Overview

You work for a SaaS company that bills customers monthly.

The business wants to identify customers who are at **churn risk** based on consistent revenue decline patterns.

Your task is to detect customers whose revenue has **strictly decreased for at least 3 consecutive calendar months**.

This is a time-series streak detection problem requiring correct handling of:
- Month-over-month comparisons
- Missing months
- Strict decline logic
- Proper grouping of consecutive patterns

---

## Table Schema

### `monthly_customer_revenue`

```sql
CREATE TABLE monthly_customer_revenue (
    customer_id INT,
    revenue_month DATE,      -- First day of month
    revenue_amount DECIMAL(12,2)
);
```
## Sample Data

### monthly_customer_revenue

| customer_id | revenue_month | revenue_amount |
|------------:|--------------|---------------:|
| 101 | 2024-01-01 | 1000 |
| 101 | 2024-02-01 | 900 |
| 101 | 2024-03-01 | 800 |
| 101 | 2024-04-01 | 700 |
| 102 | 2024-01-01 | 1200 |
| 102 | 2024-02-01 | 1150 |
| 102 | 2024-03-01 | 1150 |
| 102 | 2024-04-01 | 1000 |
| 103 | 2024-01-01 | 500 |
| 103 | 2024-03-01 | 450 |
| 103 | 2024-04-01 | 400 |
| 104 | 2024-01-01 | 800 |
| 104 | 2024-02-01 | 750 |
| 104 | 2024-03-01 | 720 |
| 104 | 2024-04-01 | 730 |

---

## Business Requirements

The business wants to identify customers who are at **churn risk** due to consistent revenue decline.

A customer qualifies if:

1. Revenue strictly decreases month-over-month:
   - `current_revenue < previous_revenue`
2. Months must be calendar-consecutive:
   - `DATEDIFF(MONTH, prev_month, current_month) = 1`
3. Flat revenue breaks the streak.
4. Revenue increase breaks the streak.
5. Missing months break the streak.
6. There must be **at least 3 consecutive declines**.

---

## Expected Output

| customer_id | decline_start_month | decline_end_month | consecutive_declines |
|------------:|--------------------|------------------|----------------------|
| 101 | 2024-02-01 | 2024-04-01 | 3 |

---

## Explanation

- **Customer 101**: 1000 → 900 → 800 → 700  
  ✔ 3 consecutive declines

- **Customer 102**: Flat revenue in March breaks streak

- **Customer 103**: Missing February breaks streak

- **Customer 104**: Revenue increases in April, breaking streak
