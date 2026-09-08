select
    payment_id,
    order_id,
    payment_method,
    payment_amount
from {{ ref('stg_jaffle_shop__payments') }}
where payment_amount < 0