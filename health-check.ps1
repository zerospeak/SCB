# Health check script for dev environment
# Usage: pwsh -File health-check.ps1

$ErrorActionPreference = 'Continue'

function Test-Http {
    param([string]$url)
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5
        return $response.StatusCode -eq 200
    } catch {
        return $false
    }
}

Write-Host "[INFO] Checking Docker containers..." -ForegroundColor Cyan
try {
    $dockerStatus = docker ps --format "table {{.Names}}\t{{.Status}}"
    Write-Host $dockerStatus
} catch {
    Write-Host "[WARNING] Docker not running or not installed." -ForegroundColor Yellow
}

# Check API health
$apiUrl = "http://localhost:5000/health" # Adjust if needed
Write-Host "[INFO] Checking API health at $apiUrl ..." -ForegroundColor Cyan
if (Test-Http $apiUrl) {
    Write-Host "[SUCCESS] API is healthy." -ForegroundColor Green
} else {
    Write-Host "[ERROR] API health check failed." -ForegroundColor Red
}

# Check Frontend health
$frontendUrl = "http://localhost:4200" # Adjust if needed
Write-Host "[INFO] Checking Frontend at $frontendUrl ..." -ForegroundColor Cyan
if (Test-Http $frontendUrl) {
    Write-Host "[SUCCESS] Frontend is up." -ForegroundColor Green
} else {
    Write-Host "[ERROR] Frontend check failed." -ForegroundColor Red
}

# Check DB container
Write-Host "[INFO] Checking DB container status..." -ForegroundColor Cyan
try {
    $dbStatus = docker ps --filter "name=sql-server" --format "{{.Status}}"
    if ($dbStatus) {
        Write-Host "[SUCCESS] DB container is running: $dbStatus" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] DB container not running." -ForegroundColor Red
    }
} catch {
    Write-Host "[WARNING] Could not check DB container status." -ForegroundColor Yellow
}

Write-Host "[INFO] Health check complete."
