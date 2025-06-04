# DEV ONLY - DO NOT USE FOR PRODUCTION
# PowerShell script to set up all frontend dependencies and Playwright browsers for dev/CI

# Only allow DB reset in development environment
if ($env:ASPNETCORE_ENVIRONMENT -and $env:ASPNETCORE_ENVIRONMENT.ToLower() -eq 'development') {
    $resetDb = Read-Host "[setup-dev.ps1] Do you want to reset the SQL Server database? This will DELETE ALL DATA in 'sql_data' volume. Type 'YES' to confirm, anything else to skip."
    if ($resetDb -eq 'YES') {
        Write-Host "[setup-dev.ps1] Stopping containers and removing SQL Server data volume..." -ForegroundColor Yellow
        docker compose down
        docker volume rm sql_data
        docker compose up -d
        Write-Host "[setup-dev.ps1] Database reset complete. Containers restarted." -ForegroundColor Green
    }
} else {
    Write-Host "[setup-dev.ps1] Database reset is only available in development environment. Current: '$($env:ASPNETCORE_ENVIRONMENT)'" -ForegroundColor Yellow
}

# Ensure Docker is running and all services are up
Write-Host "[setup-dev.ps1] Checking Docker and required services..." -ForegroundColor Cyan
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
    Write-Host "[setup-dev.ps1] Not all containers are up. Starting/rebuilding with docker compose up -d..." -ForegroundColor Yellow
    docker compose up -d
    if (-not (Wait-For-Containers)) {
        Write-Host "[setup-dev.ps1] ERROR: Containers did not become healthy in time." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[setup-dev.ps1] All containers are up and healthy." -ForegroundColor Green
}

Write-Host "[setup-dev.ps1] Setting up AngularFrontend dependencies..." -ForegroundColor Cyan
# Ensure tsconfig.json exists
if (-not (Test-Path ./AngularFrontend/tsconfig.json)) {
    Write-Host "Creating default tsconfig.json for AngularFrontend..." -ForegroundColor Yellow
    Set-Content -Path ./AngularFrontend/tsconfig.json -Value '{
  "compileOnSave": false,
  "compilerOptions": {
    "baseUrl": "./",
    "outDir": "./dist/out-tsc",
    "sourceMap": true,
    "declaration": false,
    "downlevelIteration": true,
    "experimentalDecorators": true,
    "module": "esnext",
    "moduleResolution": "node",
    "importHelpers": true,
    "target": "es2022",
    "typeRoots": ["node_modules/@types"],
    "lib": ["es2022", "dom"]
  },
  "exclude": ["node_modules", "tmp"]
}'
}
# Ensure tsconfig.app.json exists
if (-not (Test-Path ./AngularFrontend/tsconfig.app.json)) {
    Write-Host "Creating default tsconfig.app.json for AngularFrontend..." -ForegroundColor Yellow
    Set-Content -Path ./AngularFrontend/tsconfig.app.json -Value '{
  "extends": "./tsconfig.json",
  "compilerOptions": { "outDir": "./out-tsc/app", "types": [] },
  "files": ["src/main.ts", "src/polyfills.ts"],
  "include": ["src/**/*.d.ts", "src/**/*.ts"],
  "exclude": ["src/test.ts", "src/**/*.spec.ts"]
}'
}
if (-not (Test-Path ./AngularFrontend/node_modules)) {
    Write-Host "> npm install (AngularFrontend)" -ForegroundColor Yellow
    Push-Location ./AngularFrontend
    npm install @angular/material@17 playwright --save-dev --legacy-peer-deps
    if ($LASTEXITCODE -ne 0) {
        Write-Host "npm install failed in AngularFrontend" -ForegroundColor Red
        exit 1
    }
    npm install --legacy-peer-deps
    if ($LASTEXITCODE -ne 0) {
        Write-Host "npm install failed in AngularFrontend" -ForegroundColor Red
        exit 1
    }
    npx playwright install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Playwright install failed in AngularFrontend" -ForegroundColor Red
        exit 1
    }
    Pop-Location
} else {
    Write-Host "node_modules already present in AngularFrontend. Skipping npm install." -ForegroundColor Green
    Push-Location ./AngularFrontend
    npx playwright install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Playwright install failed in ReactFrontend" -ForegroundColor Red
        exit 1
    }
    Pop-Location
}

Write-Host "[setup-dev.ps1] Setting up ReactFrontend dependencies..." -ForegroundColor Cyan
if (-not (Test-Path ./ReactFrontend/node_modules)) {
    Write-Host "> npm install (ReactFrontend)" -ForegroundColor Yellow
    Push-Location ./ReactFrontend
    npm install @mui/material @emotion/react @emotion/styled axios react-router-dom playwright --save-dev
    if ($LASTEXITCODE -ne 0) {
        Write-Host "npm install failed in ReactFrontend (dev deps)" -ForegroundColor Red
        exit 1
    }
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "npm install failed in ReactFrontend" -ForegroundColor Red
        exit 1
    }
    npx playwright install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Playwright install failed in ReactFrontend" -ForegroundColor Red
        exit 1
    }
    Pop-Location
} else {
    Write-Host "node_modules already present in ReactFrontend. Skipping npm install." -ForegroundColor Green
    Push-Location ./ReactFrontend
    npx playwright install
    Pop-Location
}

Write-Host "[setup-dev.ps1] All dependencies and Playwright browsers are set up!" -ForegroundColor Green
