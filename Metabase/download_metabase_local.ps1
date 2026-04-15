$ErrorActionPreference = "Stop"

$metabaseVersion = "0.57.6.x"
$duckdbDriverVersion = "1.4.3.1"

$localDir = Join-Path $PSScriptRoot "local"
$pluginsDir = Join-Path $localDir "plugins"
$metabaseJar = Join-Path $localDir "metabase.jar"
$driverJar = Join-Path $pluginsDir "duckdb.metabase-driver.jar"

New-Item -ItemType Directory -Force -Path $localDir, $pluginsDir | Out-Null

if (-not (Test-Path $metabaseJar)) {
    $metabaseUrl = "https://downloads.metabase.com/v$metabaseVersion/metabase.jar"
    Write-Host "Baixando Metabase $metabaseVersion..."
    Invoke-WebRequest -Uri $metabaseUrl -OutFile $metabaseJar
} else {
    Write-Host "Metabase ja existe em $metabaseJar"
}

if (-not (Test-Path $driverJar)) {
    $driverUrl = "https://github.com/motherduckdb/metabase_duckdb_driver/releases/download/$duckdbDriverVersion/duckdb.metabase-driver.jar"
    Write-Host "Baixando driver DuckDB $duckdbDriverVersion..."
    Invoke-WebRequest -Uri $driverUrl -OutFile $driverJar
} else {
    Write-Host "Driver DuckDB ja existe em $driverJar"
}

Write-Host "Downloads concluidos."
