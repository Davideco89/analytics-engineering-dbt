with payments as (

    select *
    from {{ ref('stg_jaffle_shop__payments') }}

),

orders as (

    select *
    from {{ ref('stg_jaffle_shop__orders') }}

),

final as (

    select
        payments.payment_id,
        payments.order_id,
        orders.customer_id,
        orders.order_date,
        orders.order_status,
        payments.payment_method,
        1 as payment_count,
        payments.amount_cents,
        payments.payment_amount,
        payments.payment_amount = 0 as is_zero_amount
    from payments
    left join orders
        on payments.order_id = orders.order_id

)

select *
from final