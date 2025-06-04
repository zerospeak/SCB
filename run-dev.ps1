# DEV ONLY - DO NOT USE FOR PRODUCTION
# PowerShell script to reset and start the full dev environment with verbose logging and clean .NET build

Write-Host "[run-dev.ps1] Cleaning .NET solution..." -ForegroundColor Cyan
Write-Host "> dotnet clean HealthGuardSolution.sln" -ForegroundColor Yellow
dotnet clean HealthGuardSolution.sln

Write-Host "[run-dev.ps1] Cleaning Frontend bin/ and obj/ folders..." -ForegroundColor Cyan
Remove-Item -Recurse -Force ./Frontend/bin -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ./Frontend/obj -ErrorAction SilentlyContinue

Write-Host "[run-dev.ps1] Restoring .NET solution..." -ForegroundColor Cyan
Write-Host "> dotnet restore HealthGuardSolution.sln" -ForegroundColor Yellow
dotnet restore HealthGuardSolution.sln

Write-Host "[run-dev.ps1] Building .NET solution..." -ForegroundColor Cyan
Write-Host "> dotnet build HealthGuardSolution.sln -c Release
if ($LASTEXITCODE -ne 0) {
    Write-Host "dotnet build failed" -ForegroundColor Red
    exit 1
}" -ForegroundColor Yellow
dotnet build HealthGuardSolution.sln -c Release

Write-Host "[run-dev.ps1] WARNING: Dropping existing ClaimsDb database. ALL DATA WILL BE LOST." -ForegroundColor Red
docker compose exec sql-server /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Your_password123 -Q "DROP DATABASE IF EXISTS [ClaimsDb]"
Write-Host "[run-dev.ps1] Removing old migrations to ensure Identity tables are included..." -ForegroundColor Cyan
if (Test-Path ./Api/Migrations) {
    Remove-Item ./Api/Migrations/* -Force
}
Write-Host "> dotnet ef migrations add InitialIdentity -o Migrations --project Api --startup-project Api" -ForegroundColor Yellow
dotnet ef migrations add InitialIdentity -o Migrations --project Api --startup-project Api

# Check if all required containers are up and healthy
Write-Host "[run-dev.ps1] Checking Docker container health..." -ForegroundColor Cyan
$required = @('api', 'frontend', 'angularfrontend', 'reactfrontend', 'sql-server')
$healthy = $false

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
    Write-Host "[run-dev.ps1] Not all containers are up. Starting/rebuilding with docker compose up -d --build..." -ForegroundColor Yellow
    docker compose up -d --build
    if (-not (Wait-For-Containers)) {
        Write-Host "[run-dev.ps1] ERROR: Containers did not become healthy in time." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[run-dev.ps1] All containers are up and healthy." -ForegroundColor Green
}

Write-Host "[run-dev.ps1] Showing container status..." -ForegroundColor Cyan
Write-Host "> docker compose ps" -ForegroundColor Yellow
docker compose ps

Write-Host "[run-dev.ps1] Tailing logs for all services (Ctrl+C to stop)..." -ForegroundColor Cyan
Write-Host "> docker compose logs --tail=100 -f" -ForegroundColor Yellow
docker compose logs --tail=100 -f

# Best practice: Reclaim Docker space by pruning unused images/containers/volumes after all services are up
$prune = Read-Host "Prune unused Docker images/containers/volumes? (y/n)"
if ($prune -eq "y") {
    Write-Host "[run-dev.ps1] (Best Practice) Reclaiming Docker space by pruning unused images/containers/volumes..." -ForegroundColor Cyan
    docker system prune -a --volumes -f
}
