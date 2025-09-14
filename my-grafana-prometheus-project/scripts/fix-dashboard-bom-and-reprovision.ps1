param()
$ErrorActionPreference = 'Stop'

function Remove-BOMIfPresent([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { return $false }
  $bytes = [System.IO.File]::ReadAllBytes($p)
  if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    $text = [System.Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($p, $text, $utf8NoBom)
    Write-Host "Removed BOM:" $p
    return $true
  } else {
    Write-Host "No BOM:" $p
    return $false
  }
}

$scriptDir = $PSScriptRoot
$root = Join-Path $scriptDir '..'

$files = @(
  (Join-Path $scriptDir '..\grafana\dashboard-json\17175_rev2.json'),
  (Join-Path $scriptDir '..\grafana\dashboard-json\17175_rev2.json.disabled'),
  (Join-Path $scriptDir '..\grafana\provisioning\dashboards\json\17175_rev2.json')
)

foreach ($p in $files) { Remove-BOMIfPresent $p | Out-Null }

# Restore filename if it was disabled
$disabled = Join-Path $scriptDir '..\grafana\dashboard-json\17175_rev2.json.disabled'
$regular  = Join-Path $scriptDir '..\grafana\dashboard-json\17175_rev2.json'
if (Test-Path -LiteralPath $disabled) {
  if (-not (Test-Path -LiteralPath $regular)) {
    Rename-Item -LiteralPath $disabled -NewName '17175_rev2.json' -Force
    Write-Host "Restored file:" $regular
  }
}

# Restart Grafana and show recent provisioning logs
Set-Location $root
podman-compose restart grafana | Out-Host
Start-Sleep -Seconds 6
podman logs grafana --since=10m |
  Select-String -SimpleMatch -Pattern 'provision','Provisioning','provisioned','invalid character','failed to load dashboard','error' |
  ForEach-Object { $_.Line }
