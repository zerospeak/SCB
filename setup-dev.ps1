# Setup dev environment script
# Usage: pwsh -File setup-dev.ps1

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
# Check docker-compose.yml exists
if (!(Test-Path "docker-compose.yml")) {
    Write-Host "[ERROR] docker-compose.yml not found in project root." -ForegroundColor Red
    exit 1
}
# Validate docker-compose.yml
try {
    docker-compose config | Out-Null
} catch {
    Write-Host "[ERROR] docker-compose.yml is invalid. Please fix syntax errors." -ForegroundColor Red
    exit 1
}

# Stop all running Docker containers to free up ports
Write-Host "[INFO] Stopping all running Docker containers to free up ports..." -ForegroundColor Cyan
try {
    docker ps -q | ForEach-Object { docker stop $_ }
    Write-Host "[SUCCESS] All running Docker containers stopped." -ForegroundColor Green
} catch {
    Write-Host "[WARNING] Could not stop all Docker containers. Continuing..." -ForegroundColor Yellow
}

# Check required ports before starting containers (if any)
$requiredPorts = @(5000, 5002, 5003)
function Test-PortFree {
    param([int[]]$ports)
    $inUse = @()
    foreach ($port in $ports) {
        $used = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($used) { $inUse += $port }
    }
    return $inUse
}
$busy = Test-PortFree $requiredPorts
if ($busy.Count -gt 0) {
    Write-Host "[WARNING] The following ports are already in use and will be released: $($busy -join ', ')" -ForegroundColor Yellow
    foreach ($port in $busy) {
        $procs = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess | Get-Process -ErrorAction SilentlyContinue
        if ($procs) {
            foreach ($proc in $procs) {
                Write-Host "[INFO] Stopping process using port $port: $($proc.ProcessName) (PID $($proc.Id))" -ForegroundColor Yellow
                try {
                    Stop-Process -Id $proc.Id -Force
                    Write-Host "[SUCCESS] Stopped process $($proc.ProcessName) (PID $($proc.Id)) using port $port." -ForegroundColor Green
                } catch {
                    Write-Host "[ERROR] Failed to stop process $($proc.ProcessName) (PID $($proc.Id)) using port $port: $_" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "[INFO] Port $port is in use, but process could not be identified. Please free it manually." -ForegroundColor Yellow
        }
    }
    Start-Sleep -Seconds 2
    $busy = Test-PortFree $requiredPorts
    if ($busy.Count -gt 0) {
        Write-Host "[ERROR] The following ports are STILL in use after attempting to free them: $($busy -join ', ')" -ForegroundColor Red
        Write-Host "[INFO] Please investigate manually. Try rebooting your system, or check for background services or other Docker Compose projects using these ports." -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "[INFO] Installing .NET dependencies..." -ForegroundColor Cyan
try {
    dotnet restore Api/Api.csproj
    dotnet restore Api.Tests/Api.Tests.csproj
    Write-Host "[SUCCESS] .NET dependencies installed."
} catch {
    $errors += "[ERROR] .NET restore failed: $_"
    Write-Host "[WARNING] .NET restore failed, continuing..." -ForegroundColor Yellow
}

Write-Host "[INFO] Installing Angular dependencies..." -ForegroundColor Cyan
try {
    cd AngularFrontend
    npm install
    cd ..
    Write-Host "[SUCCESS] Angular dependencies installed."
} catch {
    $errors += "[ERROR] Angular npm install failed: $_"
    Write-Host "[WARNING] Angular npm install failed, continuing..." -ForegroundColor Yellow
}

Write-Host "[INFO] Installing Python ETL dependencies..." -ForegroundColor Cyan
try {
    cd Etl
    if (Test-Path requirements.txt) { pip install -r requirements.txt }
    cd ..
    Write-Host "[SUCCESS] Python dependencies installed."
} catch {
    $errors += "[ERROR] Python pip install failed: $_"
    Write-Host "[WARNING] Python pip install failed, continuing..." -ForegroundColor Yellow
}

# Copy sample env/config files if missing
Write-Host "[INFO] Checking for sample environment/config files..." -ForegroundColor Cyan
try {
    if (!(Test-Path Api/appsettings.Development.json) -and (Test-Path Api/appsettings.Development.sample.json)) {
        Copy-Item Api/appsettings.Development.sample.json Api/appsettings.Development.json
        Write-Host "[SUCCESS] Copied Api/appsettings.Development.sample.json."
    }
    if (!(Test-Path AngularFrontend/.env) -and (Test-Path AngularFrontend/.env.sample)) {
        Copy-Item AngularFrontend/.env.sample AngularFrontend/.env
        Write-Host "[SUCCESS] Copied AngularFrontend/.env.sample."
    }
    if (!(Test-Path Etl/.env) -and (Test-Path Etl/.env.sample)) {
        Copy-Item Etl/.env.sample Etl/.env
        Write-Host "[SUCCESS] Copied Etl/.env.sample."
    }
} catch {
    $errors += "[ERROR] Copying sample env/config files failed: $_"
    Write-Host "[WARNING] Copying sample env/config files failed, continuing..." -ForegroundColor Yellow
}

Write-Host "[INFO] Running initial build (API, Angular)..." -ForegroundColor Cyan
try {
    dotnet build Api/Api.csproj
    cd AngularFrontend
    npm run build
    cd ..
    Write-Host "[SUCCESS] Initial build completed."
} catch {
    $errors += "[ERROR] Initial build failed: $_"
    Write-Host "[WARNING] Initial build failed, continuing..." -ForegroundColor Yellow
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

# Check SQL Server availability before health check or DB operation
if (-not (Test-SqlServerConnection)) {
    Write-Host "[ERROR] SQL Server is not running or not accessible on port 1433." -ForegroundColor Red
    Write-Host "[INFO] Start it with: docker-compose up -d sql-server" -ForegroundColor Yellow
    $errors += "[ERROR] SQL Server not running."
} else {
    Write-Host "[INFO] Running health check..." -ForegroundColor Cyan
    try {
        pwsh -File health-check.ps1
    } catch {
        $errors += "[ERROR] Health check failed: $_"
        Write-Host "[WARNING] Health check failed, continuing..." -ForegroundColor Yellow
    }
}

if ($errors.Count -eq 0) {
    Write-Host "[SUCCESS] Dev environment setup complete!" -ForegroundColor Green
} else {
    Write-Host "[INFO] Script completed with warnings or errors:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}
