Clear-Host

function Install-App {
    param (
        [string]$Name,
        [string]$WingetId
    )

    Write-Host ""

    # Check if already installed
    $installed = winget list --id $WingetId -e 2>$null

    if ($installed -and $installed -match $WingetId) {
        Write-Host "✓ $Name is already installed." -ForegroundColor Cyan
        Pause
        return
    }

    Write-Host "Installing $Name..." -ForegroundColor Yellow

    winget install --id $WingetId -e --silent --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ $Name installed successfully." -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "✗ Failed to install $Name." -ForegroundColor Red
        Write-Host "Winget Exit Code: $LASTEXITCODE" -ForegroundColor DarkGray
    }

    Pause
}

while ($true) {

    Clear-Host

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "          Vedak IT Toolkit v1.0" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Google Chrome"
    Write-Host "2. Hubstaff"
    Write-Host "3. AnyDesk"
    Write-Host "4. Install All"
    Write-Host "0. Exit"
    Write-Host ""

    $choice = Read-Host "Select an option"

    switch ($choice) {

        "1" {
            Install-App "Google Chrome" "Google.Chrome"
        }

        "2" {
            Install-App "Hubstaff" "Netsoft.Hubstaff"
        }

        "3" {
            Install-App "AnyDesk" "AnyDeskSoftwareGmbH.AnyDesk"
        }

        "4" {

            Install-App "Google Chrome" "Google.Chrome"
            Install-App "Hubstaff" "Netsoft.Hubstaff"
            Install-App "AnyDesk" "AnyDeskSoftwareGmbH.AnyDesk"

            Write-Host ""
            Write-Host "==========================================" -ForegroundColor Green
            Write-Host "All software processing completed." -ForegroundColor Green
            Write-Host "==========================================" -ForegroundColor Green

            Pause
        }

        "0" {
            Write-Host ""
            Write-Host "Thank you for using Vedak IT Toolkit." -ForegroundColor Green
            Start-Sleep -Seconds 1
            break
        }

        Default {
            Write-Host ""
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
            Pause
        }
    }
}
