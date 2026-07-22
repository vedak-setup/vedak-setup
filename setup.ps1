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

    # 1. Install Hubstaff
    winget install --id Netsoft.Hubstaff --source winget -e --accept-package-agreements --accept-source-agreements

    Write-Host ""
    Write-Host "Disabling screenshot notifications..." -ForegroundColor Yellow

    # 2. Briefly launch Hubstaff in hidden mode for 4 seconds so Win 11 registers its App ID
    $hubstaffPath = "${env:ProgramFiles}\Hubstaff\Hubstaff.exe"
    if (Test-Path $hubstaffPath) {
        $process = Start-Process -FilePath $hubstaffPath -WindowStyle Hidden -PassThru -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 4
        if ($process -and -not $process.HasExited) {
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        }
    }

    # 3. Pause Windows Notification Service so settings write cleanly
    Get-Service -Name "WpnUserService*" | Stop-Service -Force -ErrorAction SilentlyContinue

    # 4. Turn OFF notification banners and pop-up cards in Current User Registry
    $aumids = @(
        "Netsoft.Hubstaff",
        "HubstaffClient",
        "Hubstaff"
    )

    foreach ($aumid in $aumids) {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$aumid"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "Enabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "ShowBanner" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    }

    # 5. Restart Windows Notification Service
    Get-Service -Name "WpnUserService*" | Start-Service -ErrorAction SilentlyContinue

    Write-Host "✓ Hubstaff installed & notifications disabled successfully!" -ForegroundColor Green

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
