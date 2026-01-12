# Daily Customer Order Summary (Deduplication & Aggregation)

**Domain:** SQL  
**Technology:** Microsoft SQL Server (T-SQL)  
**Difficulty:** Beginner  
**Core Concepts:** Deduplication, Window Functions, Aggregation, Date Handling

---

## 📌 Problem Overview

You are working as a **Data Engineer** for an e-commerce company.  
The analytics team requires a **daily customer-level order summary** to analyze customer purchasing behavior.

The raw orders data is ingested from upstream systems and may contain **duplicate records** due to ingestion retries or late-arriving data. The solution must ensure accurate reporting by handling these duplicates correctly.

This problem simulates a **real-world data engineering scenario**, where correctness and query structure matter more than just getting the right numbers.

---

## 🗂️ Source Table Schema

### `Orders`

```sql
CREATE TABLE Orders (
    order_id        INT,
    customer_id     INT,
    order_date      DATETIME,
    order_amount    DECIMAL(10,2),
    order_status    VARCHAR(20),
    inserted_at     DATETIME
);
```

## 🎯 Business Requirements

1. Consider only orders with `order_status = 'Completed'`.
2. If the same `order_id` appears multiple times, retain only the **latest record** based on `inserted_at`.
3. Aggregate results at a **customer and calendar-day level**.
4. Compute the following metrics:
   - Total number of completed orders per customer per day
   - Total order amount per customer per day
5. Return `order_date` as a **DATE value** (no time component).
6. The solution must use **Microsoft SQL Server (T-SQL)** syntax.

---

## 📤 Expected Output

### Output Columns

| Column Name   | Description                                |
|--------------|--------------------------------------------|
| customer_id  | Unique identifier of the customer          |
| order_date   | Order date (DATE only)                     |
| total_orders | Number of completed orders for the day     |
| total_amount | Total amount spent by the customer per day |

### Sample Output

| customer_id | order_date  | total_orders | total_amount |
|------------|------------|--------------|--------------|
| 1          | 2025-01-01 | 1            | 250.00       |
| 2          | 2025-01-02 | 2            | 500.00       |
| 3          | 2025-01-02 | 1            | 100.00       |
