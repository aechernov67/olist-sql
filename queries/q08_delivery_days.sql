-- Q8. orders + customers → для доставленных заказов (delivered, дата доставки не NULL) топ-5 штатов по медиане времени доставки в днях (date_diff('day', order_purchase_timestamp, order_delivered_customer_date)), только штаты с ≥ 1000 заказов; вывести штат, число заказов, среднее (округлить до 2) и медиану; сортировка по медиане, при равенстве — по среднему, обе по убыванию.

WITH delivered_orders AS (
    SELECT *
    FROM orders
    WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
),
all_states_info AS (
    SELECT customers.customer_state as cust_state, COUNT(*) AS positions, MEDIAN(date_diff('day', delivered_orders.order_purchase_timestamp, delivered_orders.order_delivered_customer_date)) as median_time_diff, ROUND(AVG(date_diff('day', delivered_orders.order_purchase_timestamp, delivered_orders.order_delivered_customer_date)), 2) as avg_time_diff
    FROM delivered_orders JOIN customers ON delivered_orders.customer_id = customers.customer_id
    GROUP BY customers.customer_state
)
SELECT cust_state, positions, avg_time_diff, median_time_diff
FROM all_states_info
WHERE positions >= 1000
ORDER BY median_time_diff DESC, avg_time_diff DESC
LIMIT 5;
