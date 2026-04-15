with orders as (

    select * from {{ ref('quality_orders_enriched') }}

),

final as (

    select
        order_id,
        customer_id,
        order_date,
        status,
        payment_method,
        item_lines,
        total_quantity,
        gross_amount,
        net_revenue,
        status = 'completed' as is_completed
    from orders

)

select * from final
