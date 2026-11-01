-- Q2. order_items + products + category_translation → топ-10 категорий по выручке (сумма price по всем позициям order_items): английское название категории, выручка (округлить до 2), число проданных позиций; по убыванию выручки.

WITH info AS (
    SELECT order_items.order_id, order_items.order_item_id, order_items.product_id, COALESCE(category_translation.product_category_name_english, 'no_category_name') as product_category_name, order_items.price
    FROM order_items JOIN products ON order_items.product_id = products.product_id LEFT JOIN category_translation ON products.product_category_name = category_translation.product_category_name
)
SELECT product_category_name, ROUND(SUM(price), 2) AS sum_price, COUNT(*) as sum_count
FROM info
GROUP BY product_category_name
ORDER BY sum_price DESC
LIMIT 10