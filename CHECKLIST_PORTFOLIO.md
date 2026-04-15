# Checklist de entrega para portfolio

Use este checklist antes de publicar o projeto.

## dbt

- [ ] Rodar `dbt build`.
- [ ] Confirmar que todos os testes passaram.
- [ ] Rodar `dbt docs generate`.
- [ ] Abrir `dbt docs serve` e conferir a linhagem.

Comandos:

```powershell
.\.venv\Scripts\dbt.exe build --profiles-dir .
.\.venv\Scripts\dbt.exe docs generate --profiles-dir .
.\.venv\Scripts\dbt.exe docs serve --profiles-dir .
```

## Metabase

- [ ] Abrir o Metabase local.
- [ ] Restaurar o backup salvo com `.\restore_metabase_backup.ps1`, se for uma maquina nova.
- [ ] Conferir se a conexao DuckDB esta funcionando.
- [ ] Conferir se as tabelas `analise_*` aparecem.
- [ ] Conferir se o dashboard esta atualizado.

Comando:

```powershell
cd Metabase
.\start_metabase_local.ps1
```

## Evidencias

- [x] Salvar print da visao geral.
- [x] Salvar print da pagina de clientes.
- [x] Salvar print da pagina de produtos.

Pasta:

```text
Metabase/dashboard-assets/screenshots/
```

## Backup

- [x] Parar o Metabase com `Ctrl + C`.
- [x] Rodar backup do Metabase.
- [x] Confirmar que uma nova pasta apareceu em `Metabase/backups/`.

Comando:

```powershell
cd Metabase
.\backup_metabase_local.ps1
```

## README e portfolio

- [ ] Conferir `README.md`.
- [ ] Conferir `PORTFOLIO.md`.
- [ ] Conferir se as queries principais estao em `Metabase/queries/analytics_examples.sql`.
- [ ] Conferir se os prints aparecem no repositorio ou no site do portfolio.
