# E-commerce Analytics com dbt, DuckDB e Metabase

Projeto de portfólio para demonstrar uma stack moderna de Analytics Engineering e BI:

```text
Python gera dados raw -> dbt transforma e testa -> DuckDB armazena -> Metabase entrega o dashboard
```

O case simula uma operação de e-commerce com clientes, pedidos, itens e produtos. A proposta é mostrar domínio de modelagem em camadas, qualidade de dados, documentação com dbt e visualização executiva no Metabase.

## Dashboard

O dashboard foi construído no Metabase usando as tabelas da camada `analytics`.

![Demo do dashboard](Metabase/dashboard-assets/screenshots/dashboard-demo.gif)
![Demo do dashboard](Metabase/dashboard-assets/screenshots/dashboard-demo.mp4)

Principais perguntas respondidas:

- Qual é a receita líquida total e sua evolução?
- Qual é o volume de pedidos e o ticket médio?
- Quais produtos e categorias mais geram receita?
- Como os clientes se distribuem por segmento?
- Quais clientes têm maior valor acumulado?
- Como cancelamentos e devoluções evoluem ao longo do tempo?

## Stack

- `dbt-core` e `dbt-duckdb` para transformação, testes e documentação.
- `DuckDB` como banco analítico local.
- `Metabase` para dashboard e exploração visual.
- `Python` para geração de dados sintéticos reprodutíveis.

## Dados

A base sintética é gerada por [generate_raw_data.py](scripts/generate_raw_data.py) e gravada em CSVs na pasta [seeds](seeds).

Volume atual:

| Entidade | Registros |
| --- | ---: |
| Clientes | 1.200 |
| Produtos | 120 |
| Pedidos | 12.000 |
| Itens de pedido | 23.269 |

## Camadas dbt

O projeto usa uma arquitetura em quatro camadas. Os arquivos e modelos dbt ficam em inglês, como é comum em ambientes corporativos, enquanto as tabelas/views criadas no DuckDB usam nomes em português brasileiro para facilitar a leitura do case.

| Camada | Saída no banco | Objetivo |
| --- | --- | --- |
| `raw` | `bruto_*` | Dados carregados diretamente dos CSVs (Estudo de Caso). |
| `staging` | `preparacao_*` | Limpeza, tipagem, padronização e campos básicos. |
| `quality` | `qualidade_*` | Joins, enriquecimento e regras de negócio reutilizáveis. |
| `analytics` | `analise_*` | Tabelas finais consumidas pelo Metabase. |

Fluxo principal:

```text
raw_customers          -> staging_customers          -> analytics_customers
raw_orders             -> staging_orders             -> quality_orders_enriched -> analytics_orders -> analytics_sales_daily
raw_order_items        -> staging_order_items        -> quality_order_items_enriched
raw_products           -> staging_products           -> quality_order_items_enriched -> analytics_product_performance
```

Tabelas finais usadas no dashboard:

| Modelo dbt | Tabela no DuckDB | Uso |
| --- | --- | --- |
| `analytics_customers` | `analise_clientes` | Segmentos, histórico e lifetime revenue de clientes. |
| `analytics_orders` | `analise_pedidos` | Pedidos, status, receita bruta, receita líquida e ticket. |
| `analytics_sales_daily` | `analise_vendas_diarias` | Série diária de pedidos e receita. |
| `analytics_product_performance` | `analise_desempenho_produtos` | Ranking e desempenho de produtos/categorias. |

## Testes e qualidade

O projeto valida a base com testes nativos e customizados do dbt:

- `not_null` para chaves e campos obrigatórios.
- `unique` para identificadores.
- `relationships` entre pedidos, clientes, produtos e itens.
- `accepted_values` para status, métodos de pagamento e segmentos.
- teste customizado para garantir que pedidos concluídos tenham receita positiva.

Teste customizado:

[assert_completed_orders_have_revenue.sql](tests/assert_completed_orders_have_revenue.sql)

## Como rodar o dbt

Na raiz do projeto:

```powershell
cd C:\Users\...\PROJETOS\DBT (IMPORTANTE: local onde você salvar o projeto)
.\.venv\Scripts\dbt.exe build --profiles-dir .
```

Esse comando:

```text
1. carrega os CSVs da pasta seeds
2. cria views e tabelas no DuckDB
3. executa os testes de qualidade
```

Para regenerar a base sintética:

```powershell
.\.venv\Scripts\python.exe scripts\generate_raw_data.py
.\.venv\Scripts\dbt.exe build --profiles-dir .
```

Para abrir a documentação do dbt:

```powershell
.\.venv\Scripts\dbt.exe docs generate --profiles-dir .
.\.venv\Scripts\dbt.exe docs serve --profiles-dir .
```

Depois acesse a URL exibida no terminal, normalmente:

```text
http://localhost:8080
```

## Como abrir o Metabase com o dashboard salvo

O dashboard está preservado no backup do banco interno do Metabase:

[Metabase/backups](Metabase/backups)

Na primeira execução em outra máquina, baixe o Metabase e o driver DuckDB:

```powershell
cd C:\Users\...\PROJETOS\DBT\Metabase (IMPORTANTE: local onde você salvar o projeto)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\download_metabase_local.ps1
```

Restaure o backup salvo do dashboard:

```powershell
.\restore_metabase_backup.ps1
```

Depois abra o Metabase:

```powershell
.\start_metabase_local.ps1
```

Depois acesse:

```text
http://localhost:3000
```

O banco analítico do dbt fica em:

```text
.../DBT/ecommerce.duckdb
```

## Como salvar alterações no dashboard

Depois de editar o dashboard no Metabase:

```powershell
Ctrl + C
cd C:\Users\...\DBT\Metabase
.\backup_metabase_local.ps1
```

O backup será salvo em [Metabase/backups](Metabase/backups).

## Estrutura

```text
.
├── analyses/
├── models/
│   ├── staging/
│   ├── quality/
│   └── analytics/
├── seeds/
├── scripts/
├── tests/
├── Metabase/
│   ├── backups/
│   ├── dashboard-assets/
│   │   └── screenshots/
│   ├── docs/
│   └── queries/
├── dbt_project.yml
├── profiles.yml
├── PORTFOLIO.md
└── CHECKLIST_PORTFOLIO.md
```

## Materiais de apoio

- [PORTFOLIO.md](PORTFOLIO.md): narrativa resumida do case.
- [CHECKLIST_PORTFOLIO.md](CHECKLIST_PORTFOLIO.md): checklist antes de publicar.
- [Metabase/queries/analytics_examples.sql](Metabase/queries/analytics_examples.sql): consultas usadas como base para os cards.
- [Metabase/docs/dashboard_guide.md](Metabase/docs/dashboard_guide.md): composição do dashboard.
