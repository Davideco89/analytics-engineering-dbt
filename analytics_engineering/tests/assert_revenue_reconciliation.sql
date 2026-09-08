with order_revenue as (

    select sum(total_order_amount) as revenue
    from {{ ref('fct_orders') }}

),

payment_revenue as (

    select sum(payment_amount) as revenue
    from {{ ref('fct_payments') }}

)

select
    order_revenue.revenue as order_revenue,
    payment_revenue.revenue as payment_revenue
from order_revenue
cross join payment_revenue
where order_revenue.revenue != payment_revenue.revenue