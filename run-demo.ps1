# Run full dev demo environment
# Usage: pwsh -File run-demo.ps1

$ErrorActionPreference = 'Continue'
$errors = @()

Write-Host "[INFO] Stopping any running containers..." -ForegroundColor Cyan
try {
    docker-compose down
    Write-Host "[SUCCESS] Containers stopped."
} catch {
    $errors += "[ERROR] Failed to stop containers: $_"
    Write-Host "[WARNING] Could not stop containers, continuing..." -ForegroundColor Yellow
}

function Test-PortFree {
    param([int[]]$ports)
    $inUse = @()
    foreach ($port in $ports) {
        $used = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($used) { $inUse += $port }
    }
    return $inUse
}

# Pre-build check for critical React frontend files
$reactFiles = @(
    'ReactFrontend/src/claims/ClaimsList.tsx'
)
foreach ($file in $reactFiles) {
    if (!(Test-Path $file)) {
        Write-Host "[ERROR] Required file missing: $file" -ForegroundColor Red
        Write-Host "[INFO] Please add or rename the file to match the import exactly (case-sensitive)." -ForegroundColor Yellow
        exit 1
    }
}

# Stop all running Docker containers to free up ports
Write-Host "[INFO] Stopping all running Docker containers to free up ports..." -ForegroundColor Cyan
try {
    docker ps -q | ForEach-Object { docker stop $_ }
    Write-Host "[SUCCESS] All running Docker containers stopped." -ForegroundColor Green
} catch {
    Write-Host "[WARNING] Could not stop all Docker containers. Continuing..." -ForegroundColor Yellow
}

# Check required ports before starting containers
$requiredPorts = @(5000, 5002, 5003)
$busy = Test-PortFree $requiredPorts
if ($busy.Count -gt 0) {
    Write-Host "[WARNING] The following ports are already in use and will be released: $($busy -join ', ')" -ForegroundColor Yellow
    foreach ($port in $busy) {
        $procs = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess | Get-Process -ErrorAction SilentlyContinue
        if ($procs) {
            foreach ($proc in $procs) {
                Write-Host "[INFO] Stopping process using port $port: ${proc.ProcessName} (PID ${proc.Id})" -ForegroundColor Yellow
                try {
                    Stop-Process -Id $proc.Id -Force
                    Write-Host "[SUCCESS] Stopped process ${proc.ProcessName} (PID ${proc.Id}) using port $port." -ForegroundColor Green
                } catch {
                    Write-Host "[ERROR] Failed to stop process ${proc.ProcessName} (PID ${proc.Id}) using port $port: $_" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "[INFO] Port $port is in use, but process could not be identified. Please free it manually." -ForegroundColor Yellow
        }
    }
    # Wait a moment for ports to be released
    Start-Sleep -Seconds 2
    # Re-check ports
    $busy = Test-PortFree $requiredPorts
    if ($busy.Count -gt 0) {
        Write-Host "[ERROR] The following ports are STILL in use after attempting to free them: $($busy -join ', ')" -ForegroundColor Red
        Write-Host "[INFO] Please investigate manually. Try rebooting your system, or check for background services or other Docker Compose projects using these ports." -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "[INFO] Starting required services..." -ForegroundColor Cyan
try {
    $composeOutput = docker-compose up -d 2>&1
    Write-Host $composeOutput
    if ($composeOutput -match 'Bind for .* failed: port is already allocated') {
        Write-Host "[ERROR] One or more containers failed to start due to a port conflict." -ForegroundColor Red
        Write-Host "[INFO] Check which process is using the port and stop it, or change your docker-compose.yml port mappings." -ForegroundColor Yellow
        exit 1
    }
    # Check for any containers not running
    $notRunning = docker ps -a --filter "status=exited" --format "table {{.Names}}\t{{.Status}}"
    if ($notRunning -and $notRunning -notmatch 'NAMES') {
        Write-Host "[ERROR] Some containers failed to start:" -ForegroundColor Red
        Write-Host $notRunning -ForegroundColor Red
        exit 1
    }
    Write-Host "[SUCCESS] Services started."
} catch {
    $errors += "[ERROR] Failed to start services: $_"
    Write-Host "[WARNING] Could not start services, continuing..." -ForegroundColor Yellow
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
        if ($_.Exception.Message -like '*Cannot create file*because it already exists*') {
            Write-Host "[ERROR] Database file already exists. This is a Docker volume issue." -ForegroundColor Red
            Write-Host "[INFO] To fix: docker-compose down -v && docker-compose up -d sql-server" -ForegroundColor Yellow
        }
        Write-Host "[WARNING] Database reset/seed failed, continuing..." -ForegroundColor Yellow
    }
}

Write-Host "[INFO] Opening frontend in browser..." -ForegroundColor Cyan
try {
    Start-Process "http://localhost:4200" # Adjust port if needed
    Write-Host "[SUCCESS] Frontend opened in browser."
} catch {
    $errors += "[ERROR] Could not open browser: $_"
    Write-Host "[WARNING] Could not open browser, continuing..." -ForegroundColor Yellow
}

if ($errors.Count -eq 0) {
    Write-Host "[SUCCESS] Dev demo environment is up and running!" -ForegroundColor Green
} else {
    Write-Host "[INFO] Script completed with warnings:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}

Write-Host "[INFO] Demo credentials: demo/demo or as documented."
Write-Host "[INFO] If you need a true clean slate, run: docker-compose down -v && then re-run this script."
