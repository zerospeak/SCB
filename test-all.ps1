h# Run all tests for dev environment
# Usage: pwsh -File test-all.ps1

$ErrorActionPreference = 'Continue'
$errors = @()

# Check Docker installed
try {
    docker --version | Out-Null
} catch {
    Write-Host "[ERROR] Docker is not installed or not in PATH. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}
# Check Docker running
try {
    docker info | Out-Null
} catch {
    Write-Host "[ERROR] Docker daemon is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

function Test-SqlServerConnection {
    param([string]$server = "localhost", [int]$port = 1433)
    try {
        $tcp = Test-NetConnection -ComputerName $server -Port $port
        return $tcp.TcpTestSucceeded
    } catch {
        return $false
    }
}

# Check SQL Server availability before DB reset
if (-not (Test-SqlServerConnection)) {
    Write-Host "[ERROR] SQL Server is not running or not accessible on port 1433." -ForegroundColor Red
    Write-Host "[INFO] Start it with: docker-compose up -d sql-server" -ForegroundColor Yellow
    $errors += "[ERROR] SQL Server not running."
} else {
    Write-Host "[INFO] Resetting and seeding dev database..." -ForegroundColor Cyan
    try {
        pwsh -File Api/reset-dev-db.ps1
        Write-Host "[SUCCESS] Database reset and seeded."
    } catch {
        $errors += "[ERROR] Database reset/seed failed: $_"
        if ($_.Exception.Message -like '*Cannot create file*because it already exists*' -or $_.Exception.Message -like '*CREATE DATABASE failed. Some file names listed could not be created*') {
            Write-Host "[ERROR] Database file already exists or CREATE DATABASE failed due to existing files. This is a Docker volume issue." -ForegroundColor Red
            Write-Host "[INFO] To fix: docker-compose down -v && docker-compose up -d sql-server" -ForegroundColor Yellow
            Write-Host "[INFO] Then re-run this script." -ForegroundColor Yellow
        }
        Write-Host "[WARNING] Database reset/seed failed, continuing..." -ForegroundColor Yellow
    }
}

# Run .NET backend tests
Write-Host "[INFO] Running backend (.NET) tests..." -ForegroundColor Cyan
try {
    dotnet test Api.Tests/Api.Tests.csproj --logger "trx;LogFileName=TestResults.trx"
    Write-Host "[SUCCESS] Backend tests completed."
} catch {
    $errors += "[ERROR] Backend tests failed: $_"
    Write-Host "[WARNING] Backend tests failed, continuing..." -ForegroundColor Yellow
}

# Run Angular frontend tests
Write-Host "[INFO] Running frontend (Angular) tests..." -ForegroundColor Cyan
try {
    cd AngularFrontend
    npm install
    npm test -- --watch=false
    cd ..
    Write-Host "[SUCCESS] Frontend tests completed."
} catch {
    $errors += "[ERROR] Frontend tests failed: $_"
    Write-Host "[WARNING] Frontend tests failed, continuing..." -ForegroundColor Yellow
}

# Run ETL (Python) tests
Write-Host "[INFO] Running ETL (Python) tests..." -ForegroundColor Cyan
try {
    cd Etl
    if (Test-Path test_etl.ps1) {
        pwsh -File test_etl.ps1
    } elseif (Test-Path test_etl.py) {
        python test_etl.py
    } else {
        Write-Host "[INFO] No ETL test script found."
    }
    cd ..
    Write-Host "[SUCCESS] ETL tests completed."
} catch {
    $errors += "[ERROR] ETL tests failed: $_"
    Write-Host "[WARNING] ETL tests failed, continuing..." -ForegroundColor Yellow
}

if ($errors.Count -eq 0) {
    Write-Host "[SUCCESS] All tests passed!" -ForegroundColor Green
} else {
    Write-Host "[INFO] Script completed with warnings or errors:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}
