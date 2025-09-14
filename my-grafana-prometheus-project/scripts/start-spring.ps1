# Starts the local Spring Boot app in a new window and writes its PID to a file for reliable shutdown
param(
  [string]$Title = "Spring: app (local)",
  [string]$PidFile
)

$ErrorActionPreference = 'SilentlyContinue'

# Resolve key paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projRoot = Split-Path -Parent $scriptDir                  # my-grafana-prometheus-project
$repoRoot = Split-Path -Parent $projRoot                   # podman-compose
$appDir   = Join-Path $repoRoot 'spring-boot-micrometer-docker'

# Validate app directory and script
if (-not (Test-Path $appDir)) { Write-Host "App dir not found: $appDir"; exit 1 }
if (-not (Test-Path (Join-Path $appDir 'scripts\mvn-run.bat'))) { Write-Host "mvn-run.bat not found under $appDir\scripts"; exit 1 }

# Default PID file under my-grafana-prometheus-project/tmp
if (-not $PidFile) {
  $tmpDir = Join-Path $projRoot 'tmp'
  if (-not (Test-Path $tmpDir)) { New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null }
  $PidFile = Join-Path $tmpDir 'spring-local.pid'
}

# Launch a new cmd window, set a recognizable title, then run the app's mvn script
# Use /k so the window stays open even if mvn exits quickly (to view errors/logs)
$cmdArgs = @('/k', "title $Title && call .\\scripts\\mvn-run.bat")
$proc = Start-Process -FilePath 'cmd.exe' -ArgumentList $cmdArgs -WorkingDirectory $appDir -WindowStyle Normal -PassThru

# Record the PID for later shutdown
if ($proc -and $proc.Id) {
  Set-Content -Path $PidFile -Value $proc.Id
  Write-Host "Started Spring app. PID=$($proc.Id); Title='$Title'; PID file: $PidFile"
} else {
  Write-Host "Failed to start Spring app window."
}
