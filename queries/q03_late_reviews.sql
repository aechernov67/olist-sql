-- Q3. orders + reviews → для доставленных заказов (order_status = 'delivered', дата доставки не NULL): две строки «опоздал / вовремя» (опоздал = order_delivered_customer_date > order_estimated_delivery_date), число отзывов и средняя оценка review_score (округлить до 2).

WITH info AS (
    SELECT orders.order_id, reviews.review_score, CASE WHEN orders.order_delivered_customer_date > orders.order_estimated_delivery_date THEN 'late' ELSE 'in_time' END AS result
    FROM orders JOIN reviews ON orders.order_id = reviews.order_id
    WHERE order_status = 'delivered' AND orders.order_delivered_customer_date IS NOT NULL
)
SELECT result, COUNT(*) AS orders_number, ROUND(AVG(review_score), 2) AS avg_score
FROM info
GROUP BY result
ORDER BY result DESC;
