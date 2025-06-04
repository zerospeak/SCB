# DEV ONLY - DO NOT USE FOR PRODUCTION
# Script to auto-diagnose and auto-fix syntax/config errors in all code and config files

Write-Host "[dev-diagnose.ps1] Checking JSON files..." -ForegroundColor Cyan
Get-ChildItem -Recurse -Include *.json | ForEach-Object {
    try {
        Get-Content $_.FullName | ConvertFrom-Json | Out-Null
    } catch {
        Write-Host "SYNTAX ERROR in JSON:" $_.FullName -ForegroundColor Red
    }
}

Write-Host "[dev-diagnose.ps1] Checking YAML/YML files..." -ForegroundColor Cyan
Get-ChildItem -Recurse -Include *.yml,*.yaml | ForEach-Object {
    try {
        Get-Content $_.FullName | Out-String | ConvertFrom-Yaml | Out-Null
    } catch {
        Write-Host "SYNTAX ERROR in YAML:" $_.FullName -ForegroundColor Red
    }
}

Write-Host "[dev-diagnose.ps1] Checking PowerShell scripts..." -ForegroundColor Cyan
Get-ChildItem -Recurse -Include *.ps1 | ForEach-Object {
    try {
        powershell -NoProfile -Command "[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw '$_'), [ref]$null)" | Out-Null
    } catch {
        Write-Host "SYNTAX ERROR in PS1:" $_.FullName -ForegroundColor Red
    }
}

Write-Host "[dev-diagnose.ps1] Checking TypeScript/JavaScript files..." -ForegroundColor Cyan
if (Test-Path ./AngularFrontend/tsconfig.json) {
    Push-Location ./AngularFrontend
    try {
        npx tsc --noEmit
    } catch {
        Write-Host "TypeScript errors in AngularFrontend" -ForegroundColor Red
    }
    try {
        npx eslint . --ext .ts,.js --fix
    } catch {
        Write-Host "ESLint errors in AngularFrontend" -ForegroundColor Red
    }
    Pop-Location
}
if (Test-Path ./ReactFrontend/tsconfig.json) {
    Push-Location ./ReactFrontend
    try {
        npx tsc --noEmit
    } catch {
        Write-Host "TypeScript errors in ReactFrontend" -ForegroundColor Red
    }
    try {
        npx eslint . --ext .ts,.tsx,.js --fix
    } catch {
        Write-Host "ESLint errors in ReactFrontend" -ForegroundColor Red
    }
    Pop-Location
}

Write-Host "[dev-diagnose.ps1] Checking .NET build (C# and Razor files)..." -ForegroundColor Cyan
if (Test-Path ./HealthGuardSolution.sln) {
    try {
        dotnet build ./HealthGuardSolution.sln
    } catch {
        Write-Host "dotnet build errors" -ForegroundColor Red
    }
}

Write-Host "[dev-diagnose.ps1] Diagnosis and auto-fix complete." -ForegroundColor Green
