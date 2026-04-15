with order_items as (

    select * from {{ ref('quality_order_items_enriched') }}

),

orders as (

    select order_id, status from {{ ref('staging_orders') }}

),

joined as (

    select
        order_items.product_id,
        order_items.product_name,
        order_items.category,
        order_items.is_active,
        order_items.quantity,
        order_items.gross_amount,
        orders.status
    from order_items
    left join orders
        on order_items.order_id = orders.order_id

),

final as (

    select
        product_id,
        product_name,
        category,
        is_active,
        count(*) as order_lines,
        sum(quantity) as units_sold,
        sum(gross_amount) as gross_amount,
        sum(case when status = 'completed' then gross_amount else 0 end) as net_revenue
    from joined
    group by 1, 2, 3, 4

)

select * from final
