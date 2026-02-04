# First Successful Transaction After Failure

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Event Sequencing, Filtering, CTEs

---

## Problem Statement

You are working with a **payment processing system** that records every transaction attempt along with its status.

The business wants to analyze **recovery behavior** by identifying the **first successful transaction that occurs after one or more failures** for each customer.

This analysis is commonly used in:
- Payment reliability monitoring
- Customer experience analysis
- Failure recovery reporting

---

## Table Schema

### `payment_transactions`

```sql
CREATE TABLE payment_transactions (
    transaction_id INT,
    customer_id    INT,
    transaction_ts DATETIME,
    status         VARCHAR(20) -- 'SUCCESS' or 'FAILED'
);
```
---
## Sample Data

### `payment_transactions`

| transaction_id | customer_id | transaction_ts       | status  |
|----------------|-------------|----------------------|---------|
| 1 | 101 | 2024-01-01 10:00:00 | FAILED  |
| 2 | 101 | 2024-01-01 10:05:00 | FAILED  |
| 3 | 101 | 2024-01-01 10:10:00 | SUCCESS |
| 4 | 101 | 2024-01-02 09:00:00 | SUCCESS |
| 5 | 102 | 2024-01-03 11:00:00 | FAILED  |
| 6 | 102 | 2024-01-03 11:10:00 | FAILED  |
| 7 | 103 | 2024-01-04 14:00:00 | SUCCESS |
| 8 | 104 | 2024-01-05 15:00:00 | FAILED  |
| 9 | 104 | 2024-01-05 15:30:00 | SUCCESS |

---
## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify the **first successful transaction that occurs after one or more failed transactions** for each customer.

The query must:

- Evaluate transactions **per customer**
- Process events in **chronological order**
- Return **only the first SUCCESS** that occurs **after at least one FAILED**
- Ignore customers who:
  - Never had a failed transaction
  - Never recovered with a successful transaction
- Use **T-SQL–specific syntax**
- Not modify the source data
- Be **performance-aware**

---

## Expected Output

| customer_id | transaction_id | transaction_ts       |
|-------------|----------------|----------------------|
| 101 | 3 | 2024-01-01 10:10:00 |
| 104 | 9 | 2024-01-05 15:30:00 |
