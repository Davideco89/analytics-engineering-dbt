with source as (

    select *
    from {{ source('jaffle_shop', 'payments') }}

),

renamed_and_cast as (

    select
        cast(id as int64) as payment_id,
        cast(order_id as int64) as order_id,
        lower(trim(payment_method)) as payment_method,
        cast(amount as int64) as amount_cents,
        cast(amount as numeric) / 100 as payment_amount
    from source

)

select *
from renamed_and_cast