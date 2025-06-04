# DEV ONLY - DO NOT USE FOR PRODUCTION
# Demo setup: build, run, and auto-generate demo data (PowerShell)
$ErrorActionPreference = 'Stop'

Write-Host "[0/3] Checking for EF Core migrations in Api..."
if (-not (Test-Path ./Api/Migrations)) {
    Write-Host "> dotnet ef migrations add InitialCreate -o Migrations --project Api --startup-project Api" -ForegroundColor Yellow
    dotnet ef migrations add InitialCreate -o Migrations --project Api --startup-project Api
} else {
    Write-Host "Migrations already exist. Skipping migration creation." -ForegroundColor Green
}

# Ensure Docker is running and all services are up
Write-Host "[run-demo.ps1] Checking Docker and required services..." -ForegroundColor Cyan
try {
    docker info | Out-Null
} catch {
    Write-Host "Docker does not appear to be running. Please start Docker Desktop and rerun this script." -ForegroundColor Red
    exit 1
}
$required = @('api', 'frontend', 'angularfrontend', 'reactfrontend', 'sql-server')
function Wait-For-Containers {
    param([int]$timeout = 120)
    $elapsed = 0
    while ($elapsed -lt $timeout) {
        $statuses = docker compose ps --format json | ConvertFrom-Json
        $allHealthy = $true
        foreach ($name in $required) {
            $container = $statuses | Where-Object { $_.Name -like "*$name*" }
            if (-not $container -or $container.State -notlike 'running') {
                $allHealthy = $false
                break
            }
        }
        if ($allHealthy) { return $true }
        Start-Sleep -Seconds 3
        $elapsed += 3
    }
    return $false
}
if (-not (Wait-For-Containers)) {
    Write-Host "[run-demo.ps1] Not all containers are up. Starting/rebuilding with docker compose up -d..." -ForegroundColor Yellow
    docker compose up -d
    if (-not (Wait-For-Containers)) {
        Write-Host "[run-demo.ps1] ERROR: Containers did not become healthy in time." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[run-demo.ps1] All containers are up and healthy." -ForegroundColor Green
}

Write-Host "[1/3] Building all services for demo..."
docker-compose -f "c:\temp\BCS\docker-compose.yml" up --build -d

Start-Sleep -Seconds 10
Write-Host "[2/3] Generating demo claims..."
Invoke-WebRequest -Uri "http://localhost:5000/api/claims/generate-demo-claims?count=30" -Method POST | Out-Null

Write-Host "[3/3] Opening frontend in browser..."
Start-Process "http://localhost:5002"
