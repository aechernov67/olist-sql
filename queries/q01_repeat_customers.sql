-- Q1. customers + orders → доля покупателей (человек = customer_unique_id; customer_id выдаётся на каждый заказ свой) с ≥ 2 заказами, в процентах, округлить до 2 знаков.

WITH info AS (
    SELECT orders.order_id, customers.customer_id, customers.customer_unique_id
    FROM orders JOIN customers ON orders.customer_id = customers.customer_id
),
customers_unique AS (
    SELECT customer_unique_id, COUNT(*) as orders_number
    FROM info
    GROUP BY customer_unique_id
)
SELECT ROUND(100.0 * (SELECT COUNT(*) FROM customers_unique WHERE orders_number >= 2) / (SELECT COUNT(*) FROM customers_unique), 2) as repeat_pct;
