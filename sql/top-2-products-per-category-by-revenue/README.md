# SQL Daily Practice – Top 2 Products per Category by Revenue

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Aggregation, Window Functions, Ranking, Tie Handling

---

## Problem Statement

You are analyzing product performance for the previous month.

The business wants to identify the **top 2 highest-revenue products per category**.

If multiple products tie for a rank (for example, two products tie for 2nd place), all tied products must be included.

---

## Table Schema

### `sales`

```sql
CREATE TABLE sales (
    order_id     INT,
    category     VARCHAR(100),
    product_id   INT,
    order_date   DATE,
    revenue      DECIMAL(10,2)
);
```
---
## Sample Data

### `sales`

| order_id | category     | product_id | order_date  | revenue |
|----------|-------------|------------|------------|---------|
| 1 | Electronics | 101 | 2024-09-01 | 500 |
| 2 | Electronics | 102 | 2024-09-02 | 300 |
| 3 | Electronics | 103 | 2024-09-03 | 300 |
| 4 | Electronics | 101 | 2024-09-05 | 200 |
| 5 | Furniture   | 201 | 2024-09-01 | 400 |
| 6 | Furniture   | 202 | 2024-09-02 | 250 |
| 7 | Furniture   | 203 | 2024-09-03 | 250 |

---

## Business Requirement

Write a **T-SQL query (Microsoft SQL Server)** to identify the **top 2 highest-revenue products per category**.

Rules:

1. Calculate `total_revenue` per `(category, product_id)`.
2. Rank products within each category by `total_revenue` in descending order.
3. Return only products that fall within the **top 2 ranks per category**.
4. If multiple products tie for 2nd rank, include all tied products.
5. Use T-SQL–specific syntax.
6. Do not modify source data.
7. Ensure deterministic ordering in final output.

Return the following columns:

- `category`
- `product_id`
- `total_revenue`
- `revenue_rank`

---

## Expected Output

### Electronics

| category     | product_id | total_revenue | revenue_rank |
|-------------|------------|---------------|--------------|
| Electronics | 101 | 700 | 1 |
| Electronics | 102 | 300 | 2 |
| Electronics | 103 | 300 | 2 |

### Furniture

| category   | product_id | total_revenue | revenue_rank |
|-----------|------------|---------------|--------------|
| Furniture | 201 | 400 | 1 |
| Furniture | 202 | 250 | 2 |
| Furniture | 203 | 250 | 2 |

---

### Explanation

**Electronics**
- Product 101 → 500 + 200 = 700 → Rank 1  
- Products 102 and 103 → 300 each → Tie for Rank 2  

**Furniture**
- Product 201 → 400 → Rank 1  
- Products 202 and 203 → 250 each → Tie for Rank 2  

Both tied products are included because ranking must be tie-aware.
