with orders as (

    select *
    from {{ ref('stg_jaffle_shop__orders') }}

),

payments_by_order as (

    select
        order_id,
        count(*) as payment_count,
        sum(
            case
                when payment_amount = 0 then 1
                else 0
            end
        ) as zero_amount_payment_count,
        sum(payment_amount) as total_order_amount
    from {{ ref('stg_jaffle_shop__payments') }}
    group by order_id

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.order_status,
        orders.order_age_days,
        1 as order_count,
        coalesce(payments.payment_count, 0) as payment_count,
        coalesce(payments.zero_amount_payment_count, 0) as zero_amount_payment_count,
        coalesce(payments.total_order_amount, 0) as total_order_amount,
        coalesce(payments.payment_count, 0) > 1 as has_multiple_payments,
        coalesce(payments.total_order_amount, 0) > 0 as is_paid
    from orders
    left join payments_by_order as payments
        on orders.order_id = payments.order_id

)

select *
from final