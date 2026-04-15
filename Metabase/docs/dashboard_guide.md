# Guia do dashboard

O dashboard foi pensado para recrutadores e gestores olharem primeiro o resultado visual e depois entenderem a arquitetura analítica por trás.

## Página 1: Visão geral

Objetivo: mostrar saúde comercial do e-commerce.

Cards:

- Receita líquida total.
- Total de pedidos.
- Ticket médio.
- Pedidos concluídos.
- Taxa de cancelamento.
- Receita líquida por mês.
- Pedidos por mês e status.
- Receita por método de pagamento.

Tabelas principais:

```text
analise_pedidos
analise_vendas_diarias
```

## Página 2: Clientes

Objetivo: mostrar valor e comportamento da base de clientes.

Cards:

- Clientes por segmento.
- Receita por segmento.
- Top clientes por lifetime revenue.
- Pedidos concluídos por segmento.

Tabela principal:

```text
analise_clientes
```

## Página 3: Produtos

Objetivo: mostrar quais produtos e categorias sustentam a receita.

Cards:

- Top produtos por receita.
- Receita por categoria.
- Unidades vendidas por categoria.
- Produtos ativos vs inativos.

Tabela principal:

```text
analise_desempenho_produtos
```

## Filtros recomendados

- Período.
- Status do pedido.
- Método de pagamento.
- Segmento do cliente.
- País.
- Categoria.

## Consultas

As queries de apoio ficam em:

```text
Metabase/queries/analytics_examples.sql
```
