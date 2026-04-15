# Backups do Metabase

Esta pasta guarda backups do banco interno do Metabase.

O banco interno contem:

- dashboards
- perguntas/cards
- colecoes
- conexoes cadastradas
- configuracoes da interface

Para criar um backup:

```powershell
cd C:\Users\Acer\Documents\PROJETOS\DBT\Metabase
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\backup_metabase_local.ps1
```

Antes de rodar o backup, pare o Metabase com `Ctrl + C`.

Os arquivos gerados podem ser grandes e binarios. Para um repositorio publico,
avalie se deseja versionar apenas o backup final ou manter esses arquivos fora do Git.

Para restaurar o backup salvo:

```powershell
cd C:\Users\Acer\Documents\PROJETOS\DBT\Metabase
.\restore_metabase_backup.ps1
```

O script usa automaticamente o backup mais recente.
