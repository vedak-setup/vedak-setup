Clear-Host

function Install-App {
    param (
        [string]$Name,
        [string]$WingetId
    )

    Write-Host ""
    Write-Host "Installing $Name..." -ForegroundColor Yellow

    winget install --id $WingetId -e --silent --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ $Name installed successfully." -ForegroundColor Green
    }
    else {
        Write-Host "✗ Failed to install $Name." -ForegroundColor Red
    }

    Pause
}

while ($true) {

    Clear-Host

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "        Vedak Laptop Setup v2.0" -ForegroundColor Green
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
            Write-Host "All selected software installed." -ForegroundColor Green
            Write-Host "==========================================" -ForegroundColor Green

            Pause
        }

        "0" {
            break
        }

        Default {
            Write-Host ""
            Write-Host "Invalid option." -ForegroundColor Red
            Pause
        }
    }
}
