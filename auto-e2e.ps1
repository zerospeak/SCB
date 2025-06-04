# Auto Everything Script for All Frontends
# Watches for changes, auto-fixes, auto-builds, auto-runs E2E tests, and monitors results

$ErrorActionPreference = 'Stop'

# Define frontend directories
$frontends = @(
    "c:\temp\BCS\AngularFrontend",
    "c:\temp\BCS\Frontend",
    "c:\temp\BCS\ReactFrontend"
)

# Define E2E test commands for each frontend
$e2eCommands = @{
    "AngularFrontend" = "cd c:/temp/BCS/AngularFrontend ; npx ng lint ; npx ng format:write ; npx ng build ; npx ng e2e"
    "Frontend" = "cd c:/temp/BCS/Frontend ; dotnet format ; dotnet build ; npx playwright test"
    "ReactFrontend" = "cd c:/temp/BCS/ReactFrontend ; npx eslint ./src --fix ; npx prettier --write ./src ; npm run build ; npx playwright test"
}

# Function to run E2E for a frontend
function Run-E2E($frontend) {
    Write-Host "[INFO] Running E2E for $frontend..."
    $cmd = $e2eCommands[$frontend]
    Invoke-Expression $cmd
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] $frontend E2E passed."
    } else {
        Write-Host "[FAIL] $frontend E2E failed."
    }
}

# Monitor all frontends for changes
foreach ($dir in $frontends) {
    $frontend = Split-Path $dir -Leaf
    Start-Job -ScriptBlock {
        param($dir, $frontend, $e2eCommands)
        $watcher = New-Object System.IO.FileSystemWatcher $dir -Property @{IncludeSubdirectories = $true; EnableRaisingEvents = $true}
        Register-ObjectEvent $watcher Changed -SourceIdentifier FileChanged -Action {
            Write-Host "[AUTO] Change detected in $frontend. Running auto-fix, build, and E2E..."
            $cmd = $e2eCommands[$frontend]
            Invoke-Expression $cmd
        }
        while ($true) { Start-Sleep -Seconds 10 }
    } -ArgumentList $dir, $frontend, $e2eCommands | Out-Null
}

Write-Host "[MONITOR] Auto Everything is running. Monitoring all frontends for changes..."
Write-Host "[MONITOR] Press Ctrl+C to stop."

# Keep script alive
while ($true) { Start-Sleep -Seconds 60 }
