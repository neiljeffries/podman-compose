# Kills local Spring Boot JVM processes
param(
  [int]$Port = 8080,
  [string]$PidFile
)
$ErrorActionPreference = 'SilentlyContinue'
$stopped = @()

# If a PID file is provided or found in default location, try to kill that process tree first
try {
  if (-not $PidFile) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $PidFile = Join-Path (Join-Path (Split-Path -Parent $scriptDir) 'tmp') 'spring-local.pid'
  }
  if (Test-Path $PidFile) {
    $targetProcId = Get-Content $PidFile | Select-Object -First 1
    if ($targetProcId -and ($targetProcId -as [int])) {
      # Prefer taskkill to ensure the entire process tree (cmd + java) is terminated
      try {
        taskkill /PID $targetProcId /T /F | Out-Null
        $stopped += [int]$targetProcId
        Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
      } catch {
        try {
          Stop-Process -Id $targetProcId -Force -ErrorAction Stop
          $stopped += [int]$targetProcId
          Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
        } catch {}
      }
    }
  }
} catch {}

# Stop any Java process listening on the given port
try {
  $procIds = (Get-NetTCPConnection -State Listen -LocalPort $Port | Select-Object -ExpandProperty OwningProcess) | Sort-Object -Unique
  foreach ($procId in $procIds) {
    try { Stop-Process -Id $procId -Force; $stopped += $procId } catch {}
  }
} catch {}

# Fallback: stop Java processes by command line hints
try {
  $procs = Get-CimInstance Win32_Process -Filter "Name='java.exe'"
  foreach ($p in $procs) {
    $cl = $p.CommandLine
    if ($cl -and ($cl -match 'spring-boot-micrometer-docker' -or $cl -match 'demo-0.0.1-SNAPSHOT' -or $cl -match 'org.springframework.boot')) {
      try { Stop-Process -Id $p.ProcessId -Force; $stopped += $p.ProcessId } catch {}
    }
  }
} catch {}

if ($stopped.Count -gt 0) {
  Write-Host ("Stopped Java PIDs: " + ($stopped | Sort-Object -Unique -Join ', '))
} else {
  Write-Host "No matching local Java processes found."
}
