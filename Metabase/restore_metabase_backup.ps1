$ErrorActionPreference = "Stop"

param(
    [string]$BackupPath
)

$backupsRoot = Join-Path $PSScriptRoot "backups"
$appDbDir = Join-Path $PSScriptRoot "local\app-db"

if (-not $BackupPath) {
    $latestBackup = Get-ChildItem -Path $backupsRoot -Directory |
        Where-Object { $_.Name -like "metabase-local-*" } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $latestBackup) {
        Write-Host "Nenhum backup encontrado em:"
        Write-Host $backupsRoot
        exit 1
    }

    $BackupPath = $latestBackup.FullName
}

if (-not (Test-Path $BackupPath)) {
    Write-Host "Backup nao encontrado:"
    Write-Host $BackupPath
    exit 1
}

New-Item -ItemType Directory -Force -Path $appDbDir | Out-Null

Get-ChildItem -Path $appDbDir -Force |
    Where-Object { $_.Name -ne ".gitkeep" } |
    Remove-Item -Recurse -Force

Copy-Item -Path (Join-Path $BackupPath "metabase.db*") -Destination $appDbDir -Force

Write-Host "Backup restaurado:"
Write-Host $BackupPath
Write-Host ""
Write-Host "Agora rode:"
Write-Host ".\start_metabase_local.ps1"
