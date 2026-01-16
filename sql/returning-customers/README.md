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
