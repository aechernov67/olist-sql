-- Q11. orders + customers → для людей (customer_unique_id) с ≥ 2 заказами (любой статус): число дней между 1-м и 2-м заказом по order_purchase_timestamp (date_diff('day', …)); вывести одну строку: число таких людей, среднее число дней (округлить до 1), медиану.

WITH all_info AS (
    SELECT *
    FROM orders join customers on orders.customer_id = customers.customer_id
),
with_orders_number AS (
    SELECT *, COUNT(*) OVER (PARTITION BY customer_unique_id) as orders_number
    FROM all_info
),
two_or_more_orders AS (
    select *
    from with_orders_number
    where orders_number >= 2
),
with_date_number AS (
    select *, ROW_NUMBER() over (PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp) as order_number
    from two_or_more_orders
),
first_two_orders AS (
    select *
    from with_date_number
    where order_number <= 2
),
diff as (
    select *, date_diff('day', LAG(order_purchase_timestamp) OVER (PARTITION BY customer_unique_id ORDER BY order_number), order_purchase_timestamp) as date_dif
    from first_two_orders
),
diff_last as (
    select customer_unique_id, ANY_VALUE(date_dif) as date_dif_
    FROM diff
    GROUP BY customer_unique_id
)
SELECT COUNT(*) as customers_with_two_or_more_orders, ROUND(AVG(date_dif_), 1) as avg_date_diff, MEDIAN(date_dif_) as median_date_diff
FROM diff_last