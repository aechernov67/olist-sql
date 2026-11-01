-- Q7. order_items + products + category_translation → топ-5 категорий (английское название; без перевода — исходное, без категории — 'unknown') по доле доставки: 100 · SUM(freight_value) / SUM(price), округлить до 2; только категории с ≥ 1000 позиций; вывести категорию, число позиций, долю.

WITH info AS (
    SELECT order_items.order_id, order_items.price, order_items.freight_value, order_items.product_id, COALESCE(category_translation.product_category_name_english, products.product_category_name, 'unknown') AS product_category_name_eng
    FROM order_items JOIN products ON order_items.product_id = products.product_id LEFT JOIN category_translation ON products.product_category_name = category_translation.product_category_name
),
all_cts AS (
    SELECT info.product_category_name_eng as categ_name, COUNT(*) as positions, ROUND(100.0 * SUM(info.freight_value) / SUM(info.price), 2) as freight_value_pct
    FROM info
    GROUP BY info.product_category_name_eng
)
SELECT all_cts.categ_name, all_cts.positions, all_cts.freight_value_pct
FROM all_cts
WHERE all_cts.positions >= 1000
ORDER BY all_cts.freight_value_pct DESC
LIMIT 5;
