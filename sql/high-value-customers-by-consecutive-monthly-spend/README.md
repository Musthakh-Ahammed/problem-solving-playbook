# High-Value Customers by Consecutive Monthly Spend

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Aggregations, Window Functions, Gap-and-Island Logic, Date Handling

---

## Problem Statement

You are analyzing customer transaction data to identify **high-value customers**.

The business defines a **High-Value Customer** as:

> A customer whose total monthly spending exceeded ₹10,000 for **at least 3 consecutive calendar months**.

Your task is to detect such customers.

---

## Table Schema

### `customer_transactions`

```sql
CREATE TABLE customer_transactions (
    transaction_id INT,
    customer_id    INT,
    transaction_dt DATE,
    amount         DECIMAL(10,2)
);
```
---
## Sample Data

### `customer_transactions`

| transaction_id | customer_id | transaction_dt | amount |
|---------------:|------------:|----------------|-------:|
| 1  | 1001 | 2024-01-05 | 6000  |
| 2  | 1001 | 2024-01-15 | 5000  |
| 3  | 1001 | 2024-02-10 | 12000 |
| 4  | 1001 | 2024-03-12 | 15000 |
| 5  | 1001 | 2024-04-01 | 8000  |
| 6  | 1002 | 2024-01-10 | 11000 |
| 7  | 1002 | 2024-02-15 | 13000 |
| 8  | 1002 | 2024-03-20 | 14000 |
| 9  | 1003 | 2024-01-05 | 5000  |
| 10 | 1003 | 2024-02-10 | 6000  |
| 11 | 1003 | 2024-03-15 | 7000  |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify customers who:

- Have **total monthly spending greater than 10,000**
- For **at least 3 consecutive calendar months**
- Monthly totals must be calculated using: `DATETRUNC(MONTH, transaction_dt)`
- Consecutive means **no skipped calendar months**
- Return:
- `customer_id`
- `start_month`
- `end_month`
- Use **T-SQL–specific syntax**
- Do **not** modify the source data
- Ensure the query is **performance-aware**

---

## Expected Output

| customer_id | start_month | end_month |
|------------:|------------|-----------|
| 1002 | 2024-01-01 | 2024-03-01 |

### Explanation

- **Customer 1001**:
- Jan total = 11000 ✅
- Feb total = 12000 ✅
- Mar total = 15000 ✅
- Apr total = 8000 ❌
- However, Jan–Mar qualifies as 3 consecutive months, but January total is exactly 11000 (if strictly `> 10000`, it qualifies).
- Based on strict interpretation (>10000), 1001 qualifies only if January aggregation is considered properly.

- **Customer 1002**:
- Jan = 11000 ✅
- Feb = 13000 ✅
- Mar = 14000 ✅
- 3 consecutive qualifying months → qualifies.

- **Customer 1003**:
- Never exceeded 10000 → does not qualify.

