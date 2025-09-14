# Push a synthetic log line with optional labels directly to Loki
param(
  [string]$Loki = 'http://localhost:3100',
  [string]$Message = 'hello from synthetic via PowerShell',
  [string]$Labels,
  [string]$Tenant,
  [switch]$DryRun
)

# Build labels map (comma-separated key=value)
$streamLabels = @{}
if ($Labels) {
  foreach ($pair in ($Labels -split ',')) {
    $kv = $pair.Trim() -split '=', 2
    if ($kv.Length -eq 2 -and $kv[0]) { $streamLabels[$kv[0].Trim()] = $kv[1].Trim() }
  }
}
if (-not $streamLabels.ContainsKey('job')) { $streamLabels['job'] = 'synthetic' }
if (-not $streamLabels.ContainsKey('service_name')) { $streamLabels['service_name'] = 'synthetic-app' }

# Timestamp in nanoseconds
$ts = [string]([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() * 1000000)

# Build values as an array-of-arrays (each item: [ts, line])
$values = @()
$values += , @($ts, $Message)

$body = @{
  streams = @(
    @{
      stream = $streamLabels
      values = $values
    }
  )
}
$payload = $body | ConvertTo-Json -Depth 5

$headers = @{ 'Content-Type' = 'application/json' }
if ($Tenant) { $headers['X-Scope-OrgID'] = $Tenant }

if ($DryRun) {
  Write-Host "Dry-run enabled. Payload:" -ForegroundColor Yellow
  Write-Output $payload
  Write-Host "Headers:" -ForegroundColor Yellow
  Write-Output ($headers | Out-String)
  Write-Host "Endpoint: $Loki/loki/api/v1/push" -ForegroundColor Yellow
  exit 0
}

Write-Host "Posting to $Loki/loki/api/v1/push ..."
try {
  $resp = Invoke-RestMethod -Method Post -Uri "$Loki/loki/api/v1/push" -Headers $headers -Body $payload -ErrorAction Stop
  Write-Host ('Posted successfully. Response: ' + ($resp | ConvertTo-Json -Depth 5))
} catch {
  Write-Warning ("Failed to post to Loki: " + $_.Exception.Message)
  # Try multiple ways to extract error details/body
  if ($_.ErrorDetails -and $_.ErrorDetails.Message) {
    Write-Warning $_.ErrorDetails.Message
  }
  $we = $_.Exception
  if ($we -and $we.Response) {
    try {
      $status = $null
      $desc = $null
      try { $status = [int]$we.Response.StatusCode.value__ } catch {}
      try { $desc = $we.Response.StatusDescription } catch {}
      if ($status) { Write-Warning ("HTTP $status $desc") }
      $stream = $we.Response.GetResponseStream()
      if ($stream) {
        $reader = New-Object System.IO.StreamReader($stream)
        $err = $reader.ReadToEnd()
        if ($err) { Write-Warning $err }
      }
    } catch {}
  }
}
