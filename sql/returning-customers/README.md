# Returning Customers Based on Order Gaps (T-SQL)

## 📌 Problem Overview

In an e-commerce platform, the business wants to identify **returning customers** — customers who place an order **after a long period of inactivity**.

This logic is commonly used by:
- Marketing teams for re-engagement campaigns
- Finance teams for customer lifetime analysis
- Analytics teams for cohort and retention studies

The task is to derive this behavior purely from transactional order data using **Microsoft SQL Server (T-SQL)**.

---

## 🗄️ Table Schema

### `orders`

```sql
CREATE TABLE orders (
    order_id        INT PRIMARY KEY,
    customer_id     INT NOT NULL,
    order_date      DATE NOT NULL,
    order_amount    DECIMAL(10,2) NOT NULL
);
```

## 📊 Sample Data

```sql
INSERT INTO orders (order_id, customer_id, order_date, order_amount) VALUES
(1, 101, '2023-01-05', 120.00),
(2, 101, '2023-02-10', 80.00),
(3, 101, '2023-06-15', 200.00),

(4, 102, '2023-03-01', 50.00),
(5, 102, '2023-03-20', 70.00),
(6, 102, '2023-04-10', 90.00),

(7, 103, '2023-01-10', 150.00),
(8, 103, '2023-05-20', 300.00),

(9, 104, '2023-02-01', 60.00);
```

---

## 🎯 Business Requirement

The business wants to identify **returning customers** based on inactivity gaps between their orders.

A **returning customer order** is defined as:

- An order where the gap between the current order date and the **previous order date for the same customer** is **greater than 60 days**
- The **first order** placed by a customer must **not** be considered a returning order
- Orders must be evaluated **chronologically per customer** using `order_date`
- The solution must be implemented using **T-SQL** and be suitable for large-scale analytical workloads

---

## ✅ Expected Output

Return only the orders that qualify as **returning customer orders**.

| customer_id | order_id | order_date  | previous_order_date | gap_in_days |
|------------|----------|-------------|---------------------|-------------|
| 101        | 3        | 2023-06-15  | 2023-02-10          | 125         |
| 103        | 8        | 2023-05-20  | 2023-01-10          | 130         |

---
