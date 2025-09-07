# Resolve the Windows host IP reachable from Podman and materialize prometheus.yml from template
param(
  [string]$DefaultInterfacePattern = 'IPv4.*(Ethernet|Wi-Fi|WLAN)'
)

$ErrorActionPreference = 'Stop'

# Try WSL/Podman network default gateway first (works for many setups)
$gw = (Get-NetRoute -DestinationPrefix '0.0.0.0/0' -AddressFamily IPv4 -ErrorAction SilentlyContinue | Sort-Object -Property RouteMetric | Select-Object -First 1).NextHop
$ip = $null

if ($gw) {
  # In many Podman Desktop installs, the host IP visible to the VM is the primary interface IP.
  $ip = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -and $_.IPv4DefaultGateway.NextHop -eq $gw } | Select-Object -First 1).IPv4Address.IPAddress
}

if (-not $ip) {
  # Fallback: pick first non-loopback, up, DHCP-enabled interface
  $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notmatch '^127\.' -and $_.PrefixOrigin -ne 'WellKnown' } | Sort-Object -Property InterfaceMetric | Select-Object -First 1).IPAddress
}

if (-not $ip) {
  Write-Error 'Unable to resolve a Windows host IPv4 address.'
  exit 1
}

$templatePath = Join-Path $PSScriptRoot '..\prometheus.yml.tmpl'
$outPath = Join-Path $PSScriptRoot '..\prometheus.yml'

(Get-Content $templatePath -Raw).Replace('__HOST_WINDOWS_IP__', $ip) | Set-Content $outPath -NoNewline

Write-Host "Prometheus config written with host IP $ip to $outPath"
