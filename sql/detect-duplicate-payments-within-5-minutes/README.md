# SQL Daily Practice – Detect Duplicate Payments Within 5 Minutes

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Date-Based Logic, Deduplication, Fraud Detection Pattern

---

## Problem Statement

Your payment system occasionally processes duplicate transactions due to retry logic or network failures.

The business defines a **duplicate payment** as:

> A transaction with the same `customer_id` and same `amount` occurring within **5 minutes** of the previous matching transaction.

Your task is to identify such suspicious duplicate transactions.

---

## Table Schema

### `payment_transactions`

```sql
CREATE TABLE payment_transactions (
    transaction_id INT,
    customer_id    INT,
    amount         DECIMAL(10,2),
    transaction_ts DATETIME
);
```
---
## Sample Data

### `payment_transactions`

| transaction_id | customer_id | amount | transaction_ts       |
|----------------|------------:|--------|----------------------|
| 1 | 1001 | 250.00 | 2024-10-01 10:00 |
| 2 | 1001 | 250.00 | 2024-10-01 10:03 |
| 3 | 1001 | 250.00 | 2024-10-01 11:00 |
| 4 | 1002 | 100.00 | 2024-10-01 09:00 |
| 5 | 1002 | 150.00 | 2024-10-01 09:02 |
| 6 | 1002 | 100.00 | 2024-10-01 09:04 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to detect duplicate payment transactions.

A transaction is considered a duplicate if:

1. It has the same `customer_id`
2. It has the same `amount`
3. It occurs within **5 minutes** of the previous matching transaction
4. Only the later transaction should be flagged as duplicate

The query must return:

- `transaction_id`
- `customer_id`
- `amount`
- `transaction_ts`
- `previous_transaction_ts`
- `minutes_difference`

Additional Rules:

- Compare transactions only within the same customer and same amount.
- Use `DATEDIFF(MINUTE, previous_transaction_ts, transaction_ts)` for time comparison.
- Use T-SQL–specific syntax.
- Do not modify source data.
- Ensure deterministic ordering.

---

## Expected Output

| transaction_id | customer_id | amount | transaction_ts       | previous_transaction_ts | minutes_difference |
|----------------|------------:|--------|----------------------|-------------------------|--------------------|
| 2 | 1001 | 250.00 | 2024-10-01 10:03 | 2024-10-01 10:00 | 3 |

---

## Explanation

### Customer 1001
- Transaction 2 occurs 3 minutes after transaction 1 with same amount → Duplicate.
- Transaction 3 occurs 60 minutes later → Not duplicate.

### Customer 1002
- Transaction 5 has different amount → Not duplicate.
- Transaction 6 has same amount as transaction 4, but previous matching transaction is not within 5 minutes → Not duplicate.
