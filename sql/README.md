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
