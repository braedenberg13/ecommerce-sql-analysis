-- Monthly revenue with MoM % change using LAG window function.
-- Surfaces seasonal peaks and slumps for planning.

WITH monthly AS (
  SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
    ROUND(SUM(p.payment_value), 2)                 AS revenue
  FROM orders o
  JOIN order_payments p ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY 1
)
SELECT
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month)  AS prev_month_revenue,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY month))
    / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100,
  1) AS mom_pct_change
FROM monthly
ORDER BY month;
