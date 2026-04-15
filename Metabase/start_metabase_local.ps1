$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$duckdbPath = Join-Path $projectRoot "ecommerce.duckdb"
$localDir = Join-Path $PSScriptRoot "local"
$appDbDir = Join-Path $localDir "app-db"
$pluginsDir = Join-Path $localDir "plugins"
$nativeTmpDir = Join-Path $localDir "native-tmp"
$metabaseJar = Join-Path $localDir "metabase.jar"
$driverJar = Join-Path $pluginsDir "duckdb.metabase-driver.jar"

if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Host "Java nao encontrado no PATH."
    Write-Host "Instale o Java 21 Temurin ou rode:"
    Write-Host "winget install EclipseAdoptium.Temurin.21.JRE"
    exit 1
}

if (-not (Test-Path $duckdbPath)) {
    Write-Host "Banco DuckDB nao encontrado em: $duckdbPath"
    Write-Host "Rode primeiro, na raiz do projeto:"
    Write-Host ".\.venv\Scripts\dbt.exe build --profiles-dir ."
    exit 1
}

if (-not (Test-Path $metabaseJar) -or -not (Test-Path $driverJar)) {
    Write-Host "Metabase ou driver DuckDB ainda nao foram baixados."
    Write-Host "Rode primeiro:"
    Write-Host ".\download_metabase_local.ps1"
    exit 1
}

New-Item -ItemType Directory -Force -Path $appDbDir, $pluginsDir, $nativeTmpDir | Out-Null

Unblock-File -Path $metabaseJar -ErrorAction SilentlyContinue
Unblock-File -Path $driverJar -ErrorAction SilentlyContinue

$env:MB_DB_FILE = (Join-Path $appDbDir "metabase.db")
$env:MB_PLUGINS_DIR = $pluginsDir
$env:MB_SITE_NAME = "Portfolio dbt Ecommerce"
$env:MB_SITE_LOCALE = "pt-BR"
$env:MB_START_OF_WEEK = "monday"
$env:JAVA_TOOL_OPTIONS = "-Djava.io.tmpdir=$nativeTmpDir"

Write-Host "Metabase local iniciando em http://localhost:3000"
Write-Host "No Metabase, conecte o DuckDB com este arquivo:"
Write-Host $duckdbPath.Replace("\", "/")

Set-Location $localDir
java -jar $metabaseJar
