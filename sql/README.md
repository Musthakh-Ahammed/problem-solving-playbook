# SQL Practice – Data Engineering

This repository is my **personal SQL practice log** focused on **real-world Data Engineering scenarios** using **Microsoft SQL Server (T-SQL)**.

Each folder represents **one practical problem**, modeled on situations commonly seen in production data pipelines, analytics systems, and interviews.

The goal is **depth over volume** — clean logic, correct results, and performance-aware SQL.

---

## 📁 Problems (Click to Navigate)

- 📂 **[Daily Customer Order Summary](./daily-customer-order-summary)**  
  Daily aggregation of customer orders using date-based logic.

- 📂 **[Daily Order Revenue Summary](./daily-order-revenue-summary)**  
  Revenue calculations at daily grain using aggregation patterns.

- 📂 **[Incremental Load with Deduplication](./incremental-load-with-deduplication)**  
  Incremental fact loading with deduplication — a core Data Engineering pattern.

- 📂 **[Returning Customers](./returning-customers)**  
  Identifying repeat customers using aggregation and business rules.

- 📂 **[Sessionization & Time-Based Aggregation](./sessionization-and-time-based-aggregation)**  
  Identifying sessions and calculate session-level metrics.
  
- 📂 **[Customer Order Gap Analysis](./customer-order-gap-analysis)**  
  Calculating order gaps and identify customers who are showing signs of churn risk.

- 📂 **[Latest Active Price Per Product](./latest-active-price-per-product)**  
  Generating a report that shows the latest active price per product as of a given date.

- 📂 **[Detect Customer City Re-Visits](./detect-customer-city-re-visits)**  
  Identifying customers who returned to a city they had lived in before, along with the date they returned.

- 📂 **[SCD Type 2 with Late-Arriving Data](./scd-type-2-with-late-arriving-data)**  
  Implementing a robust SCD Type-2 customer dimension in SQL Server that correctly handles late-arriving updates, attribute reversions, and full historical tracking using temporal logic.

- 📂 **[Rolling 7-Day Active Users](./rolling-7-day-active-users)**  
  Calculating rolling 7-day active users by generating a calendar date spine and counting distinct users within a date-based rolling window in SQL Server.

- 📂 **[Identify Inactive Customers Using Order Gaps](./identify-inactive-customers-using-order-gaps)**  
  Identifying customers who had a gap of 30 or more days between consecutive orders using T-SQL window functions.

- 📂 **[First Purchase per Product per Customer](./first-purchase-per-product-per-customer)**  
  Finding the first time each customer purchased each product, along with the corresponding order ID, using T-SQL.

- 📂 **[Top-Selling Product per Day](./top-selling-product-per-day)**  
  Identifying the highest-revenue product for each day using aggregated sales data in T-SQL.

- 📂 **[Repeat Customers Within 7 Days](./repeat-customers-within-7-days)**  
  Identifying customers who placed consecutive orders within 7 days using T-SQL window functions.

- 📂 **[Detect Price Changes for Products](./detect-price-changes-for-products)**  
  Detecting and reporting product price changes over time by comparing each price to its previous value using T-SQL window functions.

- 📂 **[Customers with Increasing Monthly Spend](./customers-with-increasing-monthly-spend)**  
  Identifying customers whose total monthly spending increases for at least three consecutive months using T-SQL window functions.

- 📂 **[Revenue Decline Streak Analysis](./revenue-decline-streak-analysis)**  
  Identifying consecutive revenue decline streaks per product by detecting strict day-over-day decreases and aggregating streak-level impact using T-SQL window functions.

- 📂 **[First-Time vs Returning Customers (Monthly)](./first-time-vs-returning-customers-monthly)**  
  Classifying customers as first-time or returning each month by identifying their first order month and aggregating customer counts at a monthly level.

- 📂 **[Customers Who Churned After First Purchase](./customers-who-churned-after-first-purchase)**  
  Identifying customers who churned after their first purchase by selecting those with exactly one order and extracting their purchase month and amount.

- 📂 **[Customers With Increasing Monthly Spend Trend](./customers-with-increasing-monthly-spend-trend)**  
  Identifying customers whose total monthly spending increases for at least three consecutive calendar months using T-SQL window functions and time-series continuity checks.

- 📂 **[Customer Reactivation After Inactivity](./customer-reactivation-after-inactivity)**  
  Identifying customer reactivation events by detecting orders placed after at least 60 days of inactivity using T-SQL window functions.

- 📂 **[Detect Consecutive Login Streaks](./detect-consecutive-login-streaks)**  
  Identifying users with at least three consecutive login days using the date minus row_number pattern in T-SQL.

- 📂 **[First Successful Transaction After Failure](./first-successful-transaction-after-failure)**  
  Identifying the first successful transaction that immediately follows a failed transaction for each customer.

- 📂 **[Orders Placed After a Price Drop](./orders-placed-after-a-price-drop)**  
  Identifying orders placed after a product price drop by matching each order to the latest effective price and comparing it with the previous price.

- 📂 **[Latest Non-Cancelled Shipment per Order](./latest-non-cancelled-shipment-per-order)**  
  Retrieving the most recent non-cancelled shipment for each order using T-SQL window functions.

- 📂 **[SLA Breaches & Backlog Detection](./sla-breaches-and-backlog-detection)**  
  Detecting order-level SLA breaches and identify continuous system-level backlog periods by modeling overdue orders as a daily state using T-SQL window functions.

---

## 🎯 Why This Repo Exists

- Practice **interview-relevant SQL problems**
- Build muscle memory for **common Data Engineering patterns**
- Maintain a **searchable SQL glossary**
- Improve **query quality and performance awareness**

---

## 🧠 Conventions

- SQL dialect: **Microsoft SQL Server (T-SQL)**
- One problem per folder
- Each problem focuses on:
  - Business requirement
  - Correct grain
  - Query efficiency

---

## 📝 Note

This repository is intentionally simple.  
No frameworks. No distractions. Just SQL.
