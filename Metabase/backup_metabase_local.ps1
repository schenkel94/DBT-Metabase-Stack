$ErrorActionPreference = "Stop"

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$sourceDir = Join-Path $PSScriptRoot "local\app-db"
$backupDir = Join-Path $PSScriptRoot "backups\metabase-local-$timestamp"

if (-not (Test-Path $sourceDir)) {
    Write-Host "Pasta do banco interno do Metabase nao encontrada:"
    Write-Host $sourceDir
    exit 1
}

$files = Get-ChildItem -Path $sourceDir -File -Filter "metabase.db*"

if ($files.Count -eq 0) {
    Write-Host "Nenhum arquivo metabase.db encontrado em:"
    Write-Host $sourceDir
    Write-Host "Abra o Metabase uma vez e crie seu dashboard antes de fazer backup."
    exit 1
}

New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
Copy-Item -Path $files.FullName -Destination $backupDir

Write-Host "Backup criado em:"
Write-Host $backupDir
Write-Host ""
Write-Host "Dica: faca esse backup com o Metabase parado para evitar copiar arquivos em uso."
