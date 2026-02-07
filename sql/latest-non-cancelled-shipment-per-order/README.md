# Latest Non-Cancelled Shipment per Order

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Deduplication, Conditional Filtering

---

## Problem Statement

You are working with a **shipment events table** where each order may have **multiple shipment attempts** due to cancellations, re-shipments, or operational issues.

The business wants to identify the **latest valid shipment for each order**, excluding cancelled shipments.

This is a common requirement in **logistics, fulfillment systems, and operational reporting**.

---

## Table Schema

### `order_shipments`

```sql
CREATE TABLE order_shipments (
    shipment_id   INT,
    order_id      INT,
    shipment_ts   DATETIME,
    status        VARCHAR(20) -- 'CREATED', 'SHIPPED', 'CANCELLED'
);
