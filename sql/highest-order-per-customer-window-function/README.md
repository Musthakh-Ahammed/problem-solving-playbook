# Highest Order Per Customer (Window Function)

## 📌 Problem Statement

You are given an `Orders` table that contains customer purchase data.

Write a SQL query using a **window function** to retrieve:

- `order_id`
- `customer_name`
- `total_amount`

Return **only the highest-value order for each customer**.

If a customer has multiple orders with the same highest value, return all of them.

---

## 🗂 Table Schema

```sql
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10,2)
);
```
---
## 📊 Sample Data

| order_id | customer_name | order_date  | total_amount |
|----------|--------------|------------|--------------|
| 1        | Alice        | 2024-01-10 | 300.00       |
| 2        | Alice        | 2024-01-15 | 700.00       |
| 3        | Alice        | 2024-01-20 | 700.00       |
| 4        | Bob          | 2024-02-01 | 400.00       |
| 5        | Bob          | 2024-02-10 | 900.00       |
| 6        | Charlie      | 2024-03-05 | 250.00       |

---

## 🏢 Business Requirement

The analytics team needs to determine the **highest-value order placed by each customer**.

Requirements:
- Return only the maximum `total_amount` per `customer_name`
- If multiple orders have the same highest value for a customer, include all of them
- The result should help identify top transactions for customer value analysis

---

## 🎯 Expected Output

| order_id | customer_name | total_amount |
|----------|--------------|--------------|
| 2        | Alice        | 700.00       |
| 3        | Alice        | 700.00       |
| 5        | Bob          | 900.00       |
| 6        | Charlie      | 250.00       |
