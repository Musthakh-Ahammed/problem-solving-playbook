/* ============================================================
   Top 2 Products per Category by Revenue (Tie-Aware)

   Steps:
   1. Aggregate revenue per (category, product_id)
   2. Rank products within each category
   3. Filter top 2 ranks (including ties)
   ============================================================ */

WITH product_revenue AS (
    SELECT
        category,
        product_id,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY
        category,
        product_id
),

ranked_products AS (
    SELECT
        category,
        product_id,
        total_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM product_revenue
)

SELECT
    category,
    product_id,
    total_revenue,
    revenue_rank
FROM ranked_products
WHERE revenue_rank <= 2
ORDER BY
    category,
    revenue_rank,
    product_id;
