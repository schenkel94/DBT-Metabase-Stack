with customers as (

    select * from {{ ref('staging_customers') }}

),

orders as (

    select * from {{ ref('quality_orders_enriched') }}

),

customer_orders as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(*) as total_orders,
        sum(case when status = 'completed' then 1 else 0 end) as completed_orders,
        sum(net_revenue) as lifetime_revenue
    from orders
    group by 1

),

final as (

    select
        customers.customer_id,
        customers.customer_name,
        customers.email,
        customers.signup_date,
        customers.country,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.total_orders, 0) as total_orders,
        coalesce(customer_orders.completed_orders, 0) as completed_orders,
        coalesce(customer_orders.lifetime_revenue, 0) as lifetime_revenue,
        case
            when coalesce(customer_orders.completed_orders, 0) >= 2 then 'recorrente'
            when coalesce(customer_orders.completed_orders, 0) = 1 then 'novo_comprador'
            else 'sem_compra'
        end as customer_segment
    from customers
    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

)

select * from final
