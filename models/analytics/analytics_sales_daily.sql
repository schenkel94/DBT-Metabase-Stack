with orders as (

    select * from {{ ref('analytics_orders') }}

),

final as (

    select
        order_date,
        count(*) as total_orders,
        sum(case when is_completed then 1 else 0 end) as completed_orders,
        sum(gross_amount) as gross_amount,
        sum(net_revenue) as net_revenue,
        avg(case when is_completed then net_revenue end) as avg_completed_order_value
    from orders
    group by 1

)

select * from final
