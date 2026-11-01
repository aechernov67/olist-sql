-- Q9. orders → по месяцам покупки (date_trunc('month', order_purchase_timestamp)) доля отменённых заказов (order_status = 'canceled') в процентах, округлить до 2; только месяцы с ≥ 1000 заказов; топ-5 месяцев по доле; вывести месяц, число заказов, долю.

WITH all_months AS (
    SELECT date_trunc('month', order_purchase_timestamp) as order_month, COUNT(*) as orders_number, ROUND(100.0 * COUNT(*) FILTER (order_status = 'canceled') / COUNT(*), 2) as canceled_pct
    FROM orders
    GROUP BY order_month
)
SELECT order_month, orders_number, canceled_pct
FROM all_months
WHERE orders_number >= 1000
ORDER BY canceled_pct DESC
LIMIT 5