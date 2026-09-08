with source as (

    select *
    from {{ source('jaffle_shop', 'orders') }}

),

renamed_and_cast as (

    select
        cast(id as int64) as order_id,
        cast(user_id as int64) as customer_id,
        cast(order_date as date) as order_date,
        lower(trim(status)) as order_status,
        date_diff(
            current_date(),
            cast(order_date as date),
            day
        ) as order_age_days
    from source

)

select *
from renamed_and_cast