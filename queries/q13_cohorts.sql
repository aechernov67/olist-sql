-- Q13. orders + customers → когорта человека (customer_unique_id) = месяц его первого заказа (любой статус); вывести по каждой когорте: месяц в формате 'YYYY-MM', число людей, сколько из них сделали ≥ 2 заказов, их долю в % (округлить до 2); сортировка по месяцу.

with all_info as (
    select customers.customer_unique_id, date_trunc('month', orders.order_purchase_timestamp) as order_month
    from orders join customers on orders.customer_id = customers.customer_id
),
customers_first_purchase as (
    select customer_unique_id, min(order_month) as first_order_month, count(*) as orders_number
    from all_info
    group by customer_unique_id
),
dates as (
    select first_order_month, count(*) as month_cust_number, count(*) filter (where orders_number >= 2) as month_cust_number_geq_2, round(100.0 * count(*) filter (where orders_number >= 2) / count(*), 2) as geq2_pct
    from customers_first_purchase
    group by first_order_month
)
select strftime(first_order_month, '%Y-%m') as year_month, month_cust_number, month_cust_number_geq_2, geq2_pct
from dates
order by first_order_month;
