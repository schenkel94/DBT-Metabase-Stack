with order_items as (

    select * from {{ ref('staging_order_items') }}

),

products as (

    select * from {{ ref('staging_products') }}

),

joined as (

    select
        order_items.order_item_id,
        order_items.order_id,
        order_items.product_id,
        products.product_name,
        products.category,
        products.is_active,
        order_items.quantity,
        order_items.unit_price,
        order_items.gross_amount
    from order_items
    left join products
        on order_items.product_id = products.product_id

)

select * from joined
