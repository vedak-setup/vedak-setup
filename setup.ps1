Clear-Host

function Install-Chrome {

    Clear-Host
    Write-Host ""
    Write-Host "Installing Google Chrome..." -ForegroundColor Yellow
    Write-Host ""

    winget install --id Google.Chrome --source winget -e --accept-package-agreements --accept-source-agreements

    Write-Host ""
    Write-Host "Press Enter to return to menu..."
    Read-Host
}

function Install-Hubstaff {

    Clear-Host
    Write-Host ""
    Write-Host "Installing Hubstaff..." -ForegroundColor Yellow
    Write-Host ""

    winget install --id Netsoft.Hubstaff --source winget -e --accept-package-agreements --accept-source-agreements

    Write-Host ""
    Write-Host "Press Enter to return to menu..."
    Read-Host
}

function Install-AnyDesk {

    Clear-Host
    Write-Host ""
    Write-Host "Installing AnyDesk..." -ForegroundColor Yellow
    Write-Host ""

    winget install --id AnyDeskSoftwareGmbH.AnyDesk --source winget -e --accept-package-agreements --accept-source-agreements

    Write-Host ""
    Write-Host "Press Enter to return to menu..."
    Read-Host
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
    Write-Host "0. Exit"
    Write-Host ""

    $choice = Read-Host "Select an option"

    switch ($choice) {

        "1" {
            Install-Chrome
        }

        "2" {
            Install-Hubstaff
        }

        "3" {
            Install-AnyDesk
        }

        "0" {
            break
        }

        default {
            Write-Host ""
            Write-Host "Invalid option." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}
