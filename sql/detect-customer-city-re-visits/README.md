# SQL Daily Practice – Detect Customer City Re-Visits

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Topic:** Window Functions, Event Sequencing, Deduplication

---

## Problem Statement

You are working with a customer movement history table captured from a CRM system.  
Customers can move between cities multiple times over their lifetime, including returning to a city they lived in previously.

The business wants to **identify customers who returned to a city they had lived in before**, along with the timestamp of that return.

---

## Table Schema

### `customer_location_history`

```sql
CREATE TABLE customer_location_history (
    customer_id   INT,
    customer_name VARCHAR(100),
    city          VARCHAR(100),
    moved_ts      DATETIME
);
```
---
## Sample Data

### `customer_location_history`

| customer_id | customer_name | city     | moved_ts           |
|------------|---------------|----------|--------------------|
| 1 | John  | New York | 2024-01-01 09:00 |
| 1 | John  | Boston   | 2024-02-10 10:00 |
| 1 | John  | Chicago  | 2024-03-05 08:30 |
| 1 | John  | Boston   | 2024-04-01 11:15 |
| 2 | Alice | Dallas   | 2024-01-15 14:00 |
| 2 | Alice | Austin  | 2024-02-20 16:00 |
| 3 | Mark  | Seattle | 2024-01-10 09:45 |
| 3 | Mark  | Seattle | 2024-02-01 12:00 |

---
## Business Requirement

Write a **T-SQL query (SQL Server)** to identify customers who **returned to a city they had lived in previously**.

The query must:

- Detect when a customer moves to a city that **appeared earlier in their history**
- Return the **customer ID**, **customer name**, **city**, and the **timestamp of return**
- **Ignore consecutive duplicate city records**  
  (e.g., `Seattle → Seattle` is NOT considered a return)
- Use **event ordering based on `moved_ts`**
- Not modify the source data

---

## Expected Output

| customer_id | customer_name | city   | return_ts          |
|------------|---------------|--------|--------------------|
| 1 | John | Boston | 2024-04-01 11:15 |

---
