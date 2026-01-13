
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
