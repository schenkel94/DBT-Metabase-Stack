-- Consultas para usar no editor SQL do Metabase.
-- Banco conectado: ecommerce.duckdb

-- 1. Receita liquida diaria
select
    order_date as data_pedido,
    total_orders as total_pedidos,
    completed_orders as pedidos_concluidos,
    gross_amount as receita_bruta,
    net_revenue as receita_liquida,
    avg_completed_order_value as ticket_medio
from analise_vendas_diarias
order by data_pedido;

-- 2. Receita mensal
select
    date_trunc('month', order_date) as mes,
    count(*) as total_pedidos,
    sum(case when is_completed then 1 else 0 end) as pedidos_concluidos,
    sum(net_revenue) as receita_liquida,
    avg(case when is_completed then net_revenue end) as ticket_medio
from analise_pedidos
group by 1
order by 1;

-- 3. Receita por metodo de pagamento
select
    payment_method as metodo_pagamento,
    count(*) as total_pedidos,
    sum(case when is_completed then 1 else 0 end) as pedidos_concluidos,
    sum(net_revenue) as receita_liquida,
    avg(case when is_completed then net_revenue end) as ticket_medio
from analise_pedidos
group by 1
order by receita_liquida desc;

-- 4. Top produtos por receita
select
    product_name as produto,
    category as categoria,
    units_sold as unidades_vendidas,
    gross_amount as receita_bruta,
    net_revenue as receita_liquida
from analise_desempenho_produtos
order by receita_liquida desc
limit 20;

-- 5. Segmentacao de clientes
select
    customer_segment as segmento_cliente,
    count(*) as total_clientes,
    sum(total_orders) as total_pedidos,
    sum(completed_orders) as pedidos_concluidos,
    sum(lifetime_revenue) as receita_vida_cliente,
    avg(lifetime_revenue) as receita_media_por_cliente
from analise_clientes
group by 1
order by receita_vida_cliente desc;

-- 6. Top clientes por receita
select
    customer_name as cliente,
    email,
    country as pais,
    customer_segment as segmento_cliente,
    total_orders as total_pedidos,
    completed_orders as pedidos_concluidos,
    lifetime_revenue as receita_vida_cliente
from analise_clientes
order by receita_vida_cliente desc
limit 20;

-- 7. Taxa de cancelamento e devolucao por mes
select
    date_trunc('month', order_date) as mes,
    count(*) as total_pedidos,
    sum(case when status = 'cancelled' then 1 else 0 end) as pedidos_cancelados,
    sum(case when status = 'returned' then 1 else 0 end) as pedidos_devolvidos,
    round(100.0 * sum(case when status = 'cancelled' then 1 else 0 end) / count(*), 2) as taxa_cancelamento_pct,
    round(100.0 * sum(case when status = 'returned' then 1 else 0 end) / count(*), 2) as taxa_devolucao_pct
from analise_pedidos
group by 1
order by 1;
