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

foreach ($Module in $Modules) {
    try {
        Invoke-Expression (Invoke-RestMethod "$BaseUrl/$Module")
    }
    catch {
        Write-Host ""
        Write-Host "Failed to load module: $Module" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit
    }
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

        "1" { Install-Chrome }

        "2" { Install-Hubstaff }

        "3" { Install-AnyDesk }

        "4" { Start-MicrosoftSync }

        "5" { Start-BrowserCleanup }

        "6" { Show-About }

        "7" {
            Write-Host ""
            Write-Host "Thank you for using Vedak IT Toolkit." -ForegroundColor Green
            break
        }

        default {
            Write-Host ""
            Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }

} while ($Choice -ne "7")
