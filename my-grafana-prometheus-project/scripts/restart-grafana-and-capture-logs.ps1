# filepath: c:\DeveloperApps\git\podman-compose\my-grafana-prometheus-project\scripts\restart-grafana-and-capture-logs.ps1
param(
  [string]$LogFile = (Join-Path $PSScriptRoot "..\.logs_grafana_$(Get-Date -Format yyyyMMdd_HHmmss).txt"),
  [switch]$CleanData
)

Set-Location (Join-Path $PSScriptRoot '..')

if ($CleanData) {
  Write-Host "Stopping Grafana and removing grafana-data volume..."
  podman compose stop grafana | Out-Host
  podman volume rm -f my-grafana-prometheus-project_grafana-data | Out-Host
}

Write-Host "Recreating Grafana container..."
podman compose up -d --force-recreate grafana | Out-Host

Write-Host "Capturing Grafana logs to $LogFile ..."
podman logs -f grafana *>&1 | Tee-Object -FilePath $LogFile
