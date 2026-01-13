
## 📌 Problem Overview

This SQL exercise represents a real-world reporting use case in an e-commerce environment.  
The goal is to generate a **daily revenue summary** using transactional order data in **Microsoft SQL Server (T-SQL)**.

The problem focuses on building a clean, business-aligned aggregation query suitable for analytics and reporting.

---

## 🧱 Table Schemas

### Customers
```sql
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);
```

### Orders
```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderStatus VARCHAR(20),
    OrderAmount DECIMAL(10,2)
);
```
## 📊 Sample Data

### Customers

| CustomerID | CustomerName | Country |
|-----------:|--------------|---------|
| 1          | Alice        | USA     |
| 2          | Bob          | UK      |
| 3          | Charlie      | USA     |

---

### Orders

| OrderID | CustomerID | OrderDate   | OrderStatus | OrderAmount |
|--------:|-----------:|-------------|-------------|------------:|
| 101     | 1          | 2024-01-01  | Completed   | 120.00      |
| 102     | 1          | 2024-01-01  | Cancelled   | 80.00       |
| 103     | 2          | 2024-01-01  | Completed   | 200.00      |
| 104     | 2          | 2024-01-02  | Completed   | 150.00      |
| 105     | 3          | 2024-01-02  | Completed   | 300.00      |
| 106     | 3          | 2024-01-02  | Completed   | 300.00      |

---

## 🎯 Business Requirement

The business requires a **daily revenue summary report** derived from order transactions with the following rules:

1. Only orders with `OrderStatus = 'Completed'` must be included.
2. The report should be aggregated by:
   - `OrderDate`
   - `Country`
3. The report must calculate:
   - **TotalCompletedOrders**: Total number of completed orders per day per country.
   - **TotalRevenue**: Total revenue generated from completed orders per day per country.
4. If a customer places multiple completed orders on the same day (even with the same order amount), **all orders must be counted**.
5. The final result must be sorted in ascending order by:
   - `OrderDate`
   - `Country`

---

## 📤 Expected Output

| OrderDate   | Country | TotalCompletedOrders | TotalRevenue |
|------------|---------|----------------------|--------------|
| 2024-01-01 | UK      | 1                    | 200.00       |
| 2024-01-01 | USA     | 1                    | 120.00       |
| 2024-01-02 | UK      | 1                    | 150.00       |
| 2024-01-02 | USA     | 2                    | 600.00       |
