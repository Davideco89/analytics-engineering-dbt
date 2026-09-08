with customers as (

    select *
    from {{ ref('stg_jaffle_shop__customers') }}

),

orders_by_customer as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        sum(order_count) as total_orders,
        sum(total_order_amount) as lifetime_value,
        avg(total_order_amount) as average_order_value
    from {{ ref('fct_orders') }}
    group by customer_id

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        concat(customers.first_name, ' ', customers.last_name) as full_name,
        orders.first_order_date,
        orders.most_recent_order_date,
        coalesce(orders.total_orders, 0) as total_orders,
        coalesce(orders.lifetime_value, 0) as lifetime_value,
        orders.average_order_value,
        coalesce(orders.total_orders, 0) = 1 as is_new_customer,
        coalesce(orders.total_orders, 0) > 1 as is_repeat_customer,
        case
            when coalesce(orders.total_orders, 0) = 0 then 'no_orders'
            when orders.total_orders = 1 then 'new'
            else 'repeat'
        end as customer_status
    from customers
    left join orders_by_customer as orders
        on customers.customer_id = orders.customer_id

)

select *
from final