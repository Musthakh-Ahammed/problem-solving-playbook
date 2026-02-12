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
