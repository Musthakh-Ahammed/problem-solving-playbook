# Detect Price Changes for Products

**Difficulty:** Intermediate  
**Database:** Microsoft SQL Server (T-SQL)  
**Concepts:** Window Functions, Change Detection, Event Sequencing

---

## Problem Statement

You are working with a **product pricing history table** where each record represents a product price that was effective from a given date.

Products may have multiple records where the **price does not change**.  
The business wants to identify **only the points in time when a product’s price actually changed**.

This type of logic is commonly used in **pricing analytics**, **audit reporting**, and **slowly changing dimensions (SCD)**.

---

## Table Schema

### `product_price_history`

```sql
CREATE TABLE product_price_history (
    product_id   INT,
    price        DECIMAL(10,2),
    effective_dt DATE
);
