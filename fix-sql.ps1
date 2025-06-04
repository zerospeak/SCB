# Proactive SQL Server auto-diagnose and auto-fix for ClaimsDb
# - Uses SQL authentication only
# - Reads SA password from env var (SA_PASSWORD) or fallback
# - Retries on transient errors
# - Checks SQL Server readiness before proceeding

$ErrorActionPreference = 'Stop'
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

# Get SA password from environment or fallback
$saPassword = $env:SA_PASSWORD
if (-not $saPassword) { $saPassword = 'YourStrong!Passw0rd' }

# SQL connection info
$server = 'localhost,1433'
$db = 'ClaimsDb'
$sqlcmd = "sqlcmd -S $server -U sa -P '$saPassword' -Q"

# Wait for SQL Server to be ready (max 60s)
$maxWait = 60
$waited = 0
Write-Host "[INFO] Waiting for SQL Server to be ready..."
while ($waited -lt $maxWait) {
    try {
        & sqlcmd "SELECT 1" | Out-Null
        Write-Host "[INFO] SQL Server is ready."
        break
    } catch {
        Start-Sleep -Seconds 2
        $waited += 2
        if ($waited -ge $maxWait) { $errors += "[FAIL] SQL Server not ready after $maxWait seconds."; break }
    }
}

# Retry wrapper for SQL commands
function Invoke-SqlRetry($query, $retries = 5) {
    for ($i = 0; $i -lt $retries; $i++) {
        try {
            & sqlcmd $query
            return
        } catch {
            Write-Host "[WARN] SQL error: $_. Retrying ($($i+1)/$retries)..."
            Start-Sleep -Seconds 2
        }
    }
    throw "[FAIL] SQL command failed after $retries attempts: $query"
}

# 1. Check if ClaimsDb exists
Write-Host "[INFO] Checking if ClaimsDb exists..."
$dbExists = $false
try {
    $result = & sqlcmd "SELECT name FROM sys.databases WHERE name = '$db'"
    if ($result -match $db) { $dbExists = $true }
} catch { $dbExists = $false }

if (-not $dbExists) {
    Write-Host "[AUTO] ClaimsDb does not exist. Creating ClaimsDb..."
    try {
        Invoke-SqlRetry "CREATE DATABASE [$db]"
        Write-Host "[SUCCESS] ClaimsDb created."
    } catch {
        $msg = $_.Exception.Message
        if ($msg -like '*Cannot create file*because it already exists*' -or $msg -like '*CREATE DATABASE failed. Some file names listed could not be created*') {
            Write-Host "[ERROR] Database file already exists or CREATE DATABASE failed due to existing files. This is a Docker volume issue." -ForegroundColor Red
            Write-Host "[INFO] To fix: docker-compose down -v && docker-compose up -d sql-server" -ForegroundColor Yellow
            Write-Host "[INFO] Then re-run this script." -ForegroundColor Yellow
            $errors += "[FAIL] Docker volume file conflict. Database not created." 
        } else {
            $errors += "[FAIL] SQL command failed: $_"
        }
    }
} else {
    Write-Host "[INFO] ClaimsDb already exists."
}

# 2. Run EF Core migrations (if using .NET Core backend)
$apiDir = "c:\temp\BCS\Api"
if (Test-Path "$apiDir/Api.csproj") {
    Write-Host "[INFO] Running EF Core migrations..."
    try {
        cd $apiDir ; dotnet ef database update ; cd c:\temp\BCS
        Write-Host "[SUCCESS] EF Core migrations applied."
    } catch {
        $errors += "[ERROR] EF Core migrations failed: $_"
    }
}

if ($errors.Count -eq 0) {
    Write-Host "[SUCCESS] SQL Server auto-diagnose and auto-fix complete." -ForegroundColor Green
} else {
    Write-Host "[INFO] Script completed with warnings or errors:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}
