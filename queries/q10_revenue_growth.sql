-- Q10. orders + order_items → только доставленные заказы (order_status = 'delivered'); по месяцам покупки (date_trunc('month', order_purchase_timestamp)) выручка = сумма price (округлить до 2), выручка прошлого месяца и рост к прошлому месяцу в % (округлить до 1); если прошлого календарного месяца в данных нет — прошлая выручка и рост NULL; по возрастанию месяца.

WITH delivered_orders AS (
    SELECT *
    FROM orders
    WHERE order_status = 'delivered'
),
order_items_sum_price AS (
    SELECT order_id, SUM(price) as order_price
    FROM order_items
    GROUP BY order_id
),
all_info AS (
    SELECT *
    FROM delivered_orders JOIN order_items_sum_price ON delivered_orders.order_id = order_items_sum_price.order_id
),
month_info0 AS (
    SELECT date_trunc('month', order_purchase_timestamp) as mnth, ROUND(SUM(order_price), 2) as sum_price
    FROM all_info
    GROUP BY date_trunc('month', order_purchase_timestamp)
),
month_info AS (
    SELECT mnth, sum_price, CASE WHEN date_diff('month', LAG(mnth) OVER (ORDER BY mnth), mnth) = 1 THEN LAG(sum_price) OVER (ORDER BY mnth) END AS prev_sum_price
    FROM month_info0
)
SELECT mnth, sum_price, prev_sum_price, ROUND(100.0 * (sum_price - prev_sum_price) / prev_sum_price, 1) as pct_up
FROM month_info
ORDER BY mnth;
