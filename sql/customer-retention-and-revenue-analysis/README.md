# Customer Retention & Revenue Analysis

## Problem Statement

You are given transactional sales data for an e-commerce company. The business wants to analyze customer retention and revenue performance for the year 2025.

Your task is to write SQL queries to:

1. Identify **new vs returning customers per month**
2. Calculate **monthly revenue**
3. Compute the **customer retention rate month-over-month**
4. Identify the **top 3 customers by total revenue in 2025**

---

## Database Schema

### Table: customers

| Column Name   | Data Type | Description |
|---------------|----------|-------------|
| customer_id   | INT      | Unique customer identifier |
| customer_name | VARCHAR  | Customer name |
| signup_date   | DATE     | Date customer registered |

---

### Table: orders

| Column Name | Data Type | Description |
|-------------|----------|-------------|
| order_id    | INT      | Unique order identifier |
| customer_id | INT      | FK → customers.customer_id |
| order_date  | DATE     | Date of order |
| amount      | DECIMAL  | Order total amount |

---

## Sample Data

### customers

| customer_id | customer_name | signup_date |
|------------|--------------|------------|
| 1 | Alice   | 2025-01-05 |
| 2 | Bob     | 2025-01-10 |
| 3 | Charlie | 2025-02-15 |
| 4 | David   | 2025-03-01 |
| 5 | Emma    | 2025-03-20 |

---

### orders

| order_id | customer_id | order_date  | amount |
|----------|------------|------------|--------|
| 101 | 1 | 2025-01-06 | 100 |
| 102 | 2 | 2025-01-15 | 150 |
| 103 | 1 | 2025-02-10 | 200 |
| 104 | 3 | 2025-02-20 | 300 |
| 105 | 2 | 2025-03-05 | 250 |
| 106 | 1 | 2025-03-15 | 150 |
| 107 | 4 | 2025-03-18 | 400 |
| 108 | 5 | 2025-04-01 | 500 |
| 109 | 3 | 2025-04-10 | 100 |

---

## Business Requirements

### 1. Monthly Customer Classification

For each month in 2025:

- Count of **New Customers**
  - Customers who placed their **first-ever order** in that month
- Count of **Returning Customers**
  - Customers who had at least one order before that month

---

### 2. Monthly Revenue

For each month in 2025:

- Total Revenue
- Total Orders
- Average Order Value

---

### 3. Monthly Retention Rate

Retention Rate =  

(Number of customers who ordered in both current month and previous month)  
÷  
(Number of customers who ordered in previous month)

Compute retention from February onward.

---

### 4. Top 3 Customers by Revenue (2025)

Return:

- customer_id
- customer_name
- total_orders
- total_revenue

Ordered by total_revenue DESC.

---

## Expected Output

### Output 1: Monthly Customer Classification

| month      | new_customers | returning_customers |
|------------|--------------|--------------------|
| 2025-01 | 2 | 0 |
| 2025-02 | 1 | 1 |
| 2025-03 | 1 | 2 |
| 2025-04 | 1 | 1 |

---

### Output 2: Monthly Revenue

| month      | total_revenue | total_orders | avg_order_value |
|------------|--------------|--------------|----------------|
| 2025-01 | 250 | 2 | 125 |
| 2025-02 | 500 | 2 | 250 |
| 2025-03 | 800 | 3 | 266.67 |
| 2025-04 | 600 | 2 | 300 |

---

### Output 3: Monthly Retention Rate

| month      | retention_rate |
|------------|----------------|
| 2025-02 | 0.50 |
| 2025-03 | 0.50 |
| 2025-04 | 0.50 |

---

### Output 4: Top 3 Customers by Revenue

| customer_id | customer_name | total_orders | total_revenue |
|------------|--------------|--------------|--------------|
| 1 | Alice   | 3 | 450 |
| 5 | Emma    | 1 | 500 |
| 3 | Charlie | 2 | 400 |

---

## Constraints

- Assume all dates are within 2025.
- Use standard SQL (ANSI SQL preferred).
- Do not hardcode results.
- Solutions should handle larger datasets.

---

## Objective

Write optimized SQL queries that correctly produce the expected outputs based on the provided sample data.
