-- Q6. order_items + reviews → топ-10 продавцов (seller_id) по выручке (сумма price в order_items): выручка, число разных заказов, средняя оценка review_score по отзывам на заказы с товарами продавца (каждый отзыв — один раз); всё округлить до 2.

WITH sellers_info AS (
    SELECT seller_id, ROUND(SUM(price),2) AS sum_price, COUNT(DISTINCT order_id) AS orders
    FROM order_items
    GROUP BY seller_id
),
revs AS (
    SELECT order_id, SUM(review_score) as revs_score, COUNT(*) as revs_number
    FROM reviews
    GROUP BY order_id
),
sellers_reviews AS (
    SELECT order_items.seller_id as seller_id, ANY_VALUE(revs.revs_score) as rev_score, ANY_VALUE(revs.revs_number) as rev_number
    FROM order_items JOIN revs ON order_items.order_id = revs.order_id
    GROUP BY order_items.seller_id, order_items.order_id
),
revs_unique AS (
    SELECT seller_id, ROUND(1.0 * SUM(rev_score) / SUM(rev_number), 2) as avg_rev_score
    FROM sellers_reviews
    GROUP BY seller_id
)
SELECT sellers_info.seller_id, sellers_info.sum_price, sellers_info.orders, revs_unique.avg_rev_score
FROM sellers_info JOIN revs_unique ON sellers_info.seller_id = revs_unique.seller_id
ORDER BY sellers_info.sum_price DESC
LIMIT 10;
