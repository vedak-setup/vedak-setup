# ============================================================
# Vedak IT Toolkit
# Main Launcher
# ============================================================

$BaseUrl = "https://raw.githubusercontent.com/vedak-setup/vedak-setup/v2-development/Modules"

$Modules = @(
    "Common.ps1",
    "Install-Chrome.ps1",
    "Install-Hubstaff.ps1",
    "Install-AnyDesk.ps1",
    "Microsoft-Sync.ps1",
    "Browser-Cleanup.ps1",
    "About.ps1"
)

Clear-Host

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                    Vedak IT Toolkit" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Loading modules..." -ForegroundColor Yellow
Write-Host ""

foreach ($Module in $Modules) {

    try {

        Invoke-Expression (Invoke-RestMethod "$BaseUrl/$Module")

        Write-Host ("  [OK] " + $Module) -ForegroundColor Green

    }
    catch {

        Write-Host ("  [FAILED] " + $Module) -ForegroundColor Red
        Write-Host ""
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        Read-Host "Press Enter to Exit"
        exit

    }

}

Write-Host ""
Write-Host "All modules loaded successfully." -ForegroundColor Green
Start-Sleep -Seconds 1

if (-not (Test-Internet)) {

    Show-Header "Internet Check"

    Write-ErrorMessage "Internet connection is not available."

    Pause-Toolkit
    exit

}

if (-not (Test-Winget)) {

    Show-Header "Winget Check"

    Write-ErrorMessage "Winget is not installed on this computer."

    Pause-Toolkit
    exit

}

do {

    Show-Header

    Write-Host "1. Install Google Chrome"
    Write-Host "2. Install Hubstaff"
    Write-Host "3. Install AnyDesk"
    Write-Host "4. Microsoft Sync Configuration"
    Write-Host "5. Browser Cleanup"
    Write-Host "6. About"
    Write-Host "7. Exit"
    Write-Host ""

    $Choice = Read-Host "Enter your choice"

    switch ($Choice) {

        "1" {

            Install-Chrome

        }

        "2" {

            Install-Hubstaff

        }

        "3" {

            Install-AnyDesk

        }

        "4" {

            Start-MicrosoftSync

        }

        "5" {

            Start-BrowserCleanup

        }

        "6" {

            Show-About

        }

        "7" {

            Show-Header

            Write-Success "Thank you for using Vedak IT Toolkit."

            Start-Sleep -Seconds 1

        }

        default {

            Write-Host ""
            Write-Host "Invalid choice." -ForegroundColor Red
            Start-Sleep -Seconds 2

        }

    }

}
while ($Choice -ne "7")
