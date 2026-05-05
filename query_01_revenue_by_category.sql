-- Which categories drive the most revenue each quarter?
-- Uses window functions to rank within each quarter.

WITH category_quarterly AS (
  SELECT
    DATE_TRUNC('quarter', o.order_purchase_timestamp) AS quarter,
    p.product_category_name_english                   AS category,
    ROUND(SUM(oi.price + oi.freight_value), 2)        AS total_revenue,
    COUNT(DISTINCT o.order_id)                        AS order_count
  FROM orders o
  JOIN order_items oi  ON o.order_id = oi.order_id
  JOIN products p      ON oi.product_id = p.product_id
  JOIN product_category_name_translation t
                        ON p.product_category_name = t.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY 1, 2
),
ranked AS (
  SELECT
    *,
    RANK() OVER (PARTITION BY quarter ORDER BY total_revenue DESC) AS rnk
  FROM category_quarterly
)
SELECT quarter, category, total_revenue, order_count, rnk
FROM ranked
WHERE rnk <= 5
ORDER BY quarter, rnk;
