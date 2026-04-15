select
    order_id
from {{ ref('analytics_orders') }}
where is_completed
  and net_revenue <= 0
