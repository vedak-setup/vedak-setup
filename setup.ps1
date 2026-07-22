Clear-Host

function Disable-HubstaffNotifications {
    Write-Host ""
    Write-Host "Disabling screenshot notifications..." -ForegroundColor Yellow

    # Briefly launch Hubstaff hidden so Win 11 registers its App ID
    $hubstaffPath = "${env:ProgramFiles}\Hubstaff\Hubstaff.exe"
    if (-not (Test-Path $hubstaffPath)) {
        $hubstaffPath = "${env:ProgramFiles(x86)}\Hubstaff\Hubstaff.exe"
    }

    if (Test-Path $hubstaffPath) {
        $process = Start-Process -FilePath $hubstaffPath -WindowStyle Hidden -PassThru -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 4
        if ($process -and -not $process.HasExited) {
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        }
    }

    # Pause Windows Notification Service so registry writes cleanly
    Get-Service -Name "WpnUserService*" | Stop-Service -Force -ErrorAction SilentlyContinue

    # Turn OFF notification banners and pop-up cards
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

    # Restart Windows Notification Service
    Get-Service -Name "WpnUserService*" | Start-Service -ErrorAction SilentlyContinue

    Write-Host "✓ Hubstaff screenshot notifications disabled!" -ForegroundColor Green
}

function Install-Chrome {

    Clear-Host
    Write-Host ""

    # Check if already installed
    $installed = winget list --id Google.Chrome -e 2>$null
    if ($installed -and $installed -match "Google.Chrome") {
        Write-Host "✓ Google Chrome is already installed." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Press Enter to return to menu..."
        Read-Host
        return
    }

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

    # Check if already installed
    $installed = winget list --id Netsoft.Hubstaff -e 2>$null
    if ($installed -and $installed -match "Netsoft.Hubstaff") {
        Write-Host "✓ Hubstaff is already installed." -ForegroundColor Cyan
        Disable-HubstaffNotifications
        Write-Host ""
        Write-Host "Press Enter to return to menu..."
        Read-Host
        return
    }

    Write-Host "Downloading latest Hubstaff installer directly from Hubstaff..." -ForegroundColor Yellow
    Write-Host ""

    # Download latest Hubstaff directly from official servers (always gets 1.9.4+)
    $installerPath = "$env:TEMP\HubstaffSetup.exe"
    try {
        Invoke-WebRequest -Uri "https://app.hubstaff.com/download/windows" -OutFile $installerPath -ErrorAction Stop
        Write-Host "Installing latest Hubstaff version..." -ForegroundColor Yellow
        Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
        Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Hubstaff installed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Direct download failed, attempting Winget fallback..." -ForegroundColor DarkGray
        winget install --id Netsoft.Hubstaff --source winget -e --accept-package-agreements --accept-source-agreements
    }

    # Disable notifications automatically
    Disable-HubstaffNotifications

    Write-Host ""
    Write-Host "Press Enter to return to menu..."
    Read-Host
}

function Install-AnyDesk {

    Clear-Host
    Write-Host ""

    # Check if already installed
    $installed = winget list --id AnyDeskSoftwareGmbH.AnyDesk -e 2>$null
    if ($installed -and $installed -match "AnyDeskSoftwareGmbH.AnyDesk") {
        Write-Host "✓ AnyDesk is already installed." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Press Enter to return to menu..."
        Read-Host
        return
    }

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
