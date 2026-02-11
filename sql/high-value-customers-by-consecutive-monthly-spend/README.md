# SQL Daily Practice – High-Value Customers by Consecutive Monthly Spend

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
