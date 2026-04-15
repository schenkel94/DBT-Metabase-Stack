with orders as (

    select * from {{ ref('staging_orders') }}

),

customers as (

    select * from {{ ref('staging_customers') }}

),

order_items as (

    select * from {{ ref('quality_order_items_enriched') }}

),

order_totals as (

    select
        order_id,
        count(*) as item_lines,
        sum(quantity) as total_quantity,
        sum(gross_amount) as gross_amount
    from order_items
    group by 1

),

joined as (

    select
        orders.order_id,
        orders.customer_id,
        customers.customer_name,
        customers.email,
        orders.order_date,
        orders.status,
        orders.payment_method,
        coalesce(order_totals.item_lines, 0) as item_lines,
        coalesce(order_totals.total_quantity, 0) as total_quantity,
        coalesce(order_totals.gross_amount, 0) as gross_amount,
        case
            when orders.status = 'completed' then coalesce(order_totals.gross_amount, 0)
            else 0
        end as net_revenue
    from orders
    left join customers
        on orders.customer_id = customers.customer_id
    left join order_totals
        on orders.order_id = order_totals.order_id

)

select * from joined
