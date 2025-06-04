# Lint and format all code for dev environment
# Usage: pwsh -File lint-all.ps1

$ErrorActionPreference = 'Continue'
$errors = @()

# .NET formatting
Write-Host "[INFO] Running .NET code formatter..." -ForegroundColor Cyan
try {
    dotnet format Api/Api.csproj
    Write-Host "[SUCCESS] .NET code formatted."
} catch {
    $errors += "[ERROR] .NET format failed: $_"
    Write-Host "[WARNING] .NET format failed, continuing..." -ForegroundColor Yellow
}

# Angular linting
Write-Host "[INFO] Running Angular linter..." -ForegroundColor Cyan
try {
    cd AngularFrontend
    npm install
    npm run lint
    cd ..
    Write-Host "[SUCCESS] Angular lint completed."
} catch {
    $errors += "[ERROR] Angular lint failed: $_"
    Write-Host "[WARNING] Angular lint failed, continuing..." -ForegroundColor Yellow
}

# Python linting (ETL)
Write-Host "[INFO] Running Python linter (flake8)..." -ForegroundColor Cyan
try {
    cd Etl
    if (Test-Path requirements.txt) { pip install -r requirements.txt }
    if (-not (Get-Command flake8 -ErrorAction SilentlyContinue)) {
        Write-Host "[INFO] flake8 not installed, attempting to install..." -ForegroundColor Yellow
        pip install flake8
    }
    if (Get-Command flake8 -ErrorAction SilentlyContinue) {
        flake8 .
        Write-Host "[SUCCESS] Python lint completed."
    } else {
        Write-Host "[INFO] flake8 could not be installed, skipping Python lint." -ForegroundColor Yellow
    }
    cd ..
} catch {
    $errors += "[ERROR] Python lint failed: $_"
    Write-Host "[WARNING] Python lint failed, continuing..." -ForegroundColor Yellow
}

if ($errors.Count -eq 0) {
    Write-Host "[SUCCESS] All linting/formatting passed!" -ForegroundColor Green
} else {
    Write-Host "[INFO] Script completed with warnings or errors:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}
