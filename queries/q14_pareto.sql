-- Q14. order_items → выручка продавца = SUM(price) по seller_id; разбить продавцов на 10 групп по убыванию выручки (NTILE(10), при равенстве — по seller_id); вывести одну строку: всего продавцов, сколько в верхней группе, доля их выручки от общей в % (округлить до 2).

with sellers_prices as (
    select seller_id, sum(price) as sum_price
    from order_items
    group by seller_id
),
all_info as (
    select seller_id, sum_price, ntile(10) over (order by sum_price desc, seller_id) as sum_price_number
    from sellers_prices
)
select count(*) as sellers_number, count(*) filter (where sum_price_number = 1) as first_group, round(100.0 * sum(sum_price) filter (where sum_price_number = 1) / sum(sum_price), 2) as pct
from all_info;
