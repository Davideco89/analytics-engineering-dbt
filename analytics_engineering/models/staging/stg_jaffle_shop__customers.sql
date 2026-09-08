with source as (

    select *
    from {{ source('jaffle_shop', 'customers') }}

),

renamed_and_cast as (

    select
        cast(id as int64) as customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name
    from source

)

select *
from renamed_and_cast