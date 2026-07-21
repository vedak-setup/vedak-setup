Clear-Host

function Install-App {
    param(
        [string]$Name,
        [string]$WingetId
    )

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Installing $Name..." -ForegroundColor Yellow
    Write-Host "==========================================" -ForegroundColor Cyan

    # Check if already installed
    $installed = winget list --id $WingetId --exact 2>$null

    if ($installed -match [regex]::Escape($WingetId)) {
        Write-Host ""
        Write-Host "$Name is already installed." -ForegroundColor Green
        Pause
        return
    }

    # First attempt
    winget install --id $WingetId --source winget --exact --silent --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Host "Retrying..." -ForegroundColor Yellow

        winget install --id $WingetId --exact --silent --accept-package-agreements --accept-source-agreements
    }

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "$Name installed successfully." -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "$Name installation failed." -ForegroundColor Red
        Write-Host "Exit Code : $LASTEXITCODE" -ForegroundColor DarkGray
    }

    Pause
}

while ($true) {

    Clear-Host

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "          Vedak IT Toolkit" -ForegroundColor Green
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
            Write-Host "Completed." -ForegroundColor Green
            Write-Host "==========================================" -ForegroundColor Green

            Pause
        }

        "0" {
            break
        }

        default {
            Write-Host ""
            Write-Host "Invalid option." -ForegroundColor Red
            Pause
        }
    }
}
