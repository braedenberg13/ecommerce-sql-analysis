-- Compare one-time vs. repeat buyers: order count, avg order value.
-- Repeat = more than 1 distinct order from the same customer.

WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id)      AS total_orders,
    ROUND(AVG(p.payment_value), 2)  AS avg_order_value
  FROM customers c
  JOIN orders o         ON c.customer_id = o.customer_id
  JOIN order_payments p ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT
  CASE WHEN total_orders > 1 THEN 'Repeat' ELSE 'One-Time' END AS customer_type,
  COUNT(*)                                                      AS customer_count,
  ROUND(AVG(avg_order_value), 2)                               AS mean_order_value,
  ROUND(AVG(total_orders), 2)                                  AS avg_orders_per_customer
FROM customer_orders
GROUP BY 1
ORDER BY customer_count DESC;
