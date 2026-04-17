# Metabase local

Esta pasta guarda a prova técnica de BI do projeto.

O Metabase consome o banco DuckDB gerado pelo dbt:

```text
../ecommerce.duckdb
```

E usa principalmente as tabelas:

```text
analise_clientes
analise_pedidos
analise_vendas_diarias
analise_desempenho_produtos
```

## Pastas importantes

```text
Metabase/
  backups/                    backup do banco interno do Metabase
  dashboard-assets/
    screenshots/              prints usados no README/portfolio
  docs/                       documentação do dashboard
  queries/                    SQLs de apoio
  local/                      runtime local ignorado pelo Git
```

## Requisitos

- Java 21 instalado.
- Projeto dbt executado ao menos uma vez.

Validar Java:

```powershell
java -version
```

Rodar dbt:

```powershell
cd C:\Users\...\DBT
.\.venv\Scripts\dbt.exe build --profiles-dir .
```

## Primeira execução em uma máquina nova

Baixe o Metabase e o driver DuckDB:

```powershell
cd C:\Users\...\DBT\Metabase
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\download_metabase_local.ps1
```

Depois suba:

```powershell
.\restore_metabase_backup.ps1
.\start_metabase_local.ps1
```

Abra:

```text
http://localhost:3000
```

## Conexão DuckDB

No Metabase, a conexão deve apontar para a pasta clonada:

```text
C:/Users/.../DBT/ecommerce.duckdb
```

Campos que devem ficar vazios:

```text
Motherduck Token
Azure transport option type
Init SQL
```

## Dashboard salvo

O Metabase salva dashboards, perguntas/cards e conexões no banco interno dele.
Neste projeto, o backup fica em:

```text
Metabase/backups/
```

Para restaurar o dashboard salvo em uma máquina nova:

```powershell
.\restore_metabase_backup.ps1
```

Para salvar uma alteração feita no dashboard:

1. Pare o Metabase com `Ctrl + C`.
2. Rode:

```powershell
.\backup_metabase_local.ps1
```

## Screenshots

Os prints usados no README ficam em:

```text
Metabase/dashboard-assets/screenshots/
```

Arquivos atuais:

```text
dashboard-visao-geral.png
dashboard-clientes.png
dashboard-produtos.png
```

## SQLs de apoio

As consultas usadas como base para os cards estão em:

```text
Metabase/queries/analytics_examples.sql
```
