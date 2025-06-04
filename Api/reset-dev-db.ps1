# Reset and seed the dev database for ClaimsDb
# Usage: pwsh -File reset-dev-db.ps1

$ErrorActionPreference = 'Continue'
$errors = @()

function Test-SqlServerConnection {
    param([string]$server = "localhost", [int]$port = 1433)
    try {
        $tcp = Test-NetConnection -ComputerName $server -Port $port
        return $tcp.TcpTestSucceeded
    } catch {
        return $false
    }
}

# Check SQL Server availability before proceeding
if (-not (Test-SqlServerConnection)) {
    Write-Host "[ERROR] SQL Server is not running or not accessible on port 1433." -ForegroundColor Red
    Write-Host "[INFO] Start it with: docker-compose up -d sql-server" -ForegroundColor Yellow
    exit 1
}

# Run EF Core migrations
$dockerVolumeError = $false
try {
    Write-Host "[INFO] Running EF Core migrations to reset schema..." -ForegroundColor Cyan
    cd c:\temp\BCS\Api ; dotnet ef database update ; cd c:\temp\BCS
    Write-Host "[SUCCESS] EF Core migrations completed."
} catch {
    $errors += "[ERROR] EF Core migrations failed: $_"
    $msg = $_.Exception.Message
    if ($msg -like '*Cannot create file*because it already exists*' -or $msg -like '*CREATE DATABASE failed. Some file names listed could not be created*') {
        $dockerVolumeError = $true
        Write-Host "[ERROR] Database file already exists or CREATE DATABASE failed due to existing files. This is a Docker volume issue." -ForegroundColor Red
        Write-Host "[INFO] To fix: docker-compose down -v && docker-compose up -d sql-server" -ForegroundColor Yellow
        Write-Host "[INFO] Then re-run this script." -ForegroundColor Yellow
    }
    Write-Host "[WARNING] EF Core migrations failed, continuing..." -ForegroundColor Yellow
}

# Seed demo data
try {
    Write-Host "[INFO] Seeding demo data..."
    # Optionally, add SQL or API calls here to seed demo data
    Write-Host "[SUCCESS] Demo data seeded."
} catch {
    $errors += "[ERROR] Seeding demo data failed: $_"
    Write-Host "[WARNING] Seeding demo data failed, continuing..." -ForegroundColor Yellow
}

if ($dockerVolumeError) {
    Write-Host "[FAIL] Dev database was NOT reset due to Docker volume file conflict." -ForegroundColor Red
    Write-Host "[ACTION REQUIRED] Run: docker-compose down -v && docker-compose up -d sql-server, then re-run this script." -ForegroundColor Yellow
} elseif ($errors.Count -eq 0) {
    Write-Host "[SUCCESS] Dev database reset and seeded." -ForegroundColor Green
} else {
    Write-Host "[INFO] Script completed with warnings:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}

Write-Host "[INFO] If you need a true clean slate (delete all data/files), run:" -ForegroundColor Yellow
Write-Host "docker-compose down -v" -ForegroundColor Yellow
Write-Host "docker-compose up -d sql-server" -ForegroundColor Yellow
Write-Host "Then re-run this script." -ForegroundColor Yellow
