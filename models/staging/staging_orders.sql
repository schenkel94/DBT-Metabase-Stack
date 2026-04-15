with source as (

    select * from {{ ref('raw_orders') }}

),

renamed as (

    select
        cast(order_id as integer) as order_id,
        cast(customer_id as integer) as customer_id,
        cast(order_date as date) as order_date,
        lower(trim(status)) as status,
        lower(trim(payment_method)) as payment_method
    from source

)

select * from renamed
