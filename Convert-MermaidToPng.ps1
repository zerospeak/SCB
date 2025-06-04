<#
.SYNOPSIS
Converts a Mermaid diagram file (.mmd) to PNG format with defensive checks for Node.js and Mermaid CLI.
.DESCRIPTION
- Checks if Node.js is installed and running.
- Checks if Mermaid CLI (mmdc) is installed; if not, installs it.
- Converts the specified Mermaid diagram file to PNG.
.PARAMETER InputFile
Path to the Mermaid (.mmd) file you want to convert.
.PARAMETER OutputFile
Desired output PNG file name (default: diagram.png).
.EXAMPLE
.\Convert-MermaidToPng.ps1 -InputFile "mydiagram.mmd" -OutputFile "mydiagram.png"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,
    [string]$OutputFile = "diagram.png"
)

# 1. Check if input file exists
if (-not (Test-Path $InputFile)) {
    Write-Host "Input Mermaid file '$InputFile' not found. Please provide a valid .mmd file." -ForegroundColor Red
    exit 1
}

# 2. Check Node.js
Write-Host "Checking for Node.js..."
$nodeInstalled = $false
try {
    node --version | Out-Null
    if ($LASTEXITCODE -eq 0) { $nodeInstalled = $true }
} catch { $nodeInstalled = $false }

if (-not $nodeInstalled) {
    Write-Host "Node.js not found. Please install Node.js and re-run this script." -ForegroundColor Red
    exit 1
}

# 3. Check Mermaid CLI
Write-Host "Checking for Mermaid CLI (mmdc)..."
$mmdcInstalled = $false
try {
    mmdc --version | Out-Null
    if ($LASTEXITCODE -eq 0) { $mmdcInstalled = $true }
} catch { $mmdcInstalled = $false }

if (-not $mmdcInstalled) {
    Write-Host "Mermaid CLI not found. Installing globally via npm..." -ForegroundColor Yellow
    npm install -g @mermaid-js/mermaid-cli
    # Refresh environment to pick up mmdc
    $env:Path += ";$($env:APPDATA)\npm"
    try {
        mmdc --version | Out-Null
        if ($LASTEXITCODE -eq 0) { $mmdcInstalled = $true }
    } catch { $mmdcInstalled = $false }
    if (-not $mmdcInstalled) {
        Write-Host "Failed to install Mermaid CLI. Please check your npm installation." -ForegroundColor Red
        exit 1
    }
}

# 4. Convert Mermaid to PNG
Write-Host "Converting Mermaid diagram to PNG..."
mmdc -i $InputFile -o $OutputFile
if ($LASTEXITCODE -eq 0) {
    Write-Host "PNG generated successfully: $OutputFile" -ForegroundColor Green
} else {
    Write-Host "Failed to generate PNG. Please check for errors above." -ForegroundColor Red
}
