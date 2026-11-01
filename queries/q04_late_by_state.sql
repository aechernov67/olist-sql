-- Q4. orders + customers → для доставленных заказов (как в Q3) топ-5 штатов (customer_state) по доле опозданий в процентах (округлить до 2), только штаты с ≥ 1000 таких заказов; вывести штат, число заказов, долю.

WITH info AS (
    SELECT customers.customer_state, orders.order_delivered_customer_date, orders.order_estimated_delivery_date
    FROM orders JOIN customers ON orders.customer_id = customers.customer_id
    WHERE orders.order_status = 'delivered'
)
SELECT customer_state, ROUND(100.0 * COUNT(*) FILTER (order_delivered_customer_date > order_estimated_delivery_date AND order_delivered_customer_date IS NOT NULL) / COUNT(*) FILTER (order_delivered_customer_date IS NOT NULL), 2) AS late_pct, COUNT(*) as orders_numbers
FROM info
GROUP BY customer_state
HAVING COUNT(*) >= 1000
ORDER BY late_pct DESC
LIMIT 5
