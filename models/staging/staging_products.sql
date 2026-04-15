with source as (

    select * from {{ ref('raw_products') }}

),

renamed as (

    select
        cast(product_id as integer) as product_id,
        trim(product_name) as product_name,
        trim(category) as category,
        cast(unit_price as decimal(12, 2)) as unit_price,
        cast(is_active as boolean) as is_active
    from source

)

select * from renamed
