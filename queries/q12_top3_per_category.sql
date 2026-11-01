-- Q12. order_items + products + category_translation → в каждой категории (английское название; если перевода нет — исходное; если категории нет — 'unknown') топ-3 товара (product_id) по выручке = сумма price по всем позициям; ровно 3 товара на категорию, ничьи разбивать по product_id; вывести категорию, product_id, выручку (округлить до 2), место; по категории, затем по месту.

WITH all_info AS (
    SELECT order_items.product_id, order_items.price, COALESCE(category_translation.product_category_name_english, products.product_category_name, 'unknown') AS category_name0
    FROM order_items JOIN products ON order_items.product_id = products.product_id LEFT JOIN category_translation ON products.product_category_name = category_translation.product_category_name
),
info0 AS (
    SELECT ANY_VALUE(category_name0) as category_name, product_id, ROUND(SUM(price), 2) AS sum_price
    FROM all_info
    GROUP BY product_id
),
info AS (
    SELECT category_name, product_id, sum_price, ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY sum_price DESC, product_id) AS position
    FROM info0
)
SELECT category_name, product_id, sum_price, position
FROM info
WHERE position <= 3
ORDER BY category_name, position;
