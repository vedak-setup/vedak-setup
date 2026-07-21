function Install-App {
    param (
        [string]$Name,
        [string]$WingetId
    )

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Installing $Name..." -ForegroundColor Yellow
    Write-Host "==========================================" -ForegroundColor Cyan

    # -----------------------------
    # Check if already installed
    # -----------------------------
    $installed = winget list --id $WingetId --source winget -e 2>$null

    if (-not $installed) {
        $installed = winget list --id $WingetId -e 2>$null
    }

    if ($installed -match $WingetId) {
        Write-Host ""
        Write-Host "✓ $Name is already installed." -ForegroundColor Green
        Pause
        return
    }

    # -----------------------------
    # Attempt 1
    # -----------------------------
    Write-Host ""
    Write-Host "Trying Winget source..." -ForegroundColor Yellow

    winget install `
        --id $WingetId `
        --source winget `
        -e `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ $Name installed successfully." -ForegroundColor Green
        Pause
        return
    }

    Write-Host ""
    Write-Host "First attempt failed." -ForegroundColor Yellow

    # -----------------------------
    # Attempt 2
    # -----------------------------
    Write-Host ""
    Write-Host "Trying default Winget..." -ForegroundColor Yellow

    winget install `
        --id $WingetId `
        -e `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ $Name installed successfully." -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "✗ Installation failed." -ForegroundColor Red
        Write-Host "Exit Code: $LASTEXITCODE" -ForegroundColor DarkGray
    }

    Pause
}
