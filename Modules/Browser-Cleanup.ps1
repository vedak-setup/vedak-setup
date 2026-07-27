# ==============================================================================
# Module: Browser Cleanup
# Script Name: Browser-Cleanup.ps1
# Description: Automated cleanup for Google Chrome and Microsoft Edge
# ==============================================================================

function Get-ChromeUserProfiles {

    param([string]$UserDataPath)

    $Profiles = @()

    if (Test-Path $UserDataPath) {

        if (Test-Path (Join-Path $UserDataPath "Default")) {
            $Profiles += (Join-Path $UserDataPath "Default")
        }

        Get-ChildItem $UserDataPath -Directory -Filter "Profile *" -ErrorAction SilentlyContinue | ForEach-Object {
            $Profiles += $_.FullName
        }

    }

    return $Profiles

}

function Get-EdgeUserProfiles {

    param([string]$UserDataPath)

    $Profiles = @()

    if (Test-Path $UserDataPath) {

        if (Test-Path (Join-Path $UserDataPath "Default")) {
            $Profiles += (Join-Path $UserDataPath "Default")
        }

        Get-ChildItem $UserDataPath -Directory -Filter "Profile *" -ErrorAction SilentlyContinue | ForEach-Object {
            $Profiles += $_.FullName
        }

    }

    return $Profiles

}

function Invoke-ChromeCleanup {

    Show-Header "Google Chrome Cleanup"

    $ChromeInstalled = Test-Path "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" `
        -or Test-Path "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe" `
        -or Test-Path "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"

    if (-not $ChromeInstalled) {

        Write-WarningMessage "Google Chrome is not installed."
        Write-WarningMessage "Nothing to clean."

        Pause-Toolkit
        return

    }

    $Chrome = Get-Process chrome -ErrorAction SilentlyContinue

    if ($Chrome) {

        Write-Info "Chrome Status : Running"
        Write-Host ""

        Write-Info "Closing Google Chrome..."

        Stop-Process -Name chrome -Force -ErrorAction SilentlyContinue

        Start-Sleep 2

        Write-Success "Google Chrome closed successfully."

    }
    else {

        Write-Info "Chrome Status : Closed"

    }

    Write-Host ""

    Write-Info "Cleaning Chrome browser data..."

    $UserData = "$env:LOCALAPPDATA\Google\Chrome\User Data"

    foreach ($Profile in Get-ChromeUserProfiles $UserData) {

        Remove-Item "$Profile\History" -Force -ErrorAction SilentlyContinue
        Remove-Item "$Profile\Cookies" -Force -ErrorAction SilentlyContinue
        Remove-Item "$Profile\Network\Cookies" -Force -ErrorAction SilentlyContinue

        @("Cache", "Code Cache", "GPUCache") | ForEach-Object {
            $Folder = Join-Path $Profile $_
            if (Test-Path $Folder) {
                Remove-Item "$Folder\*" -Force -Recurse -ErrorAction SilentlyContinue
            }
        }

    }

    Write-Success "Google Chrome cleanup completed."

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "Removed: Browsing History, Cookies, Cache, Download History" -ForegroundColor Green
    Write-Host "Preserved: Downloads Folder, Bookmarks, Saved Passwords, Extensions" -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan

    Pause-Toolkit

}

function Invoke-EdgeCleanup {

    Show-Header "Microsoft Edge Cleanup"

    $EdgeInstalled = Test-Path "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe" `
        -or Test-Path "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"

    if (-not $EdgeInstalled) {

        Write-WarningMessage "Microsoft Edge is not installed."
        Write-WarningMessage "Nothing to clean."

        Pause-Toolkit
        return

    }

    $Edge = Get-Process msedge -ErrorAction SilentlyContinue

    if ($Edge) {

        Write-Info "Edge Status : Running"
        Write-Host ""

        Write-Info "Closing Microsoft Edge..."

        Stop-Process -Name msedge -Force -ErrorAction SilentlyContinue

        Start-Sleep 2

        Write-Success "Microsoft Edge closed successfully."

    }
    else {

        Write-Info "Edge Status : Closed"

    }

    Write-Host ""

    Write-Info "Cleaning Edge browser data..."

    $EdgeUserData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    foreach ($Profile in Get-EdgeUserProfiles $EdgeUserData) {

        Remove-Item "$Profile\History" -Force -ErrorAction SilentlyContinue
        Remove-Item "$Profile\Cookies" -Force -ErrorAction SilentlyContinue
        Remove-Item "$Profile\Network\Cookies" -Force -ErrorAction SilentlyContinue

        @("Cache", "Code Cache", "GPUCache") | ForEach-Object {
            $Folder = Join-Path $Profile $_
            if (Test-Path $Folder) {
                Remove-Item "$Folder\*" -Force -Recurse -ErrorAction SilentlyContinue
            }
        }

    }

    Write-Success "Microsoft Edge cleanup completed."

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "Removed: Browsing History, Cookies, Cache, Download History" -ForegroundColor Green
    Write-Host "Preserved: Downloads Folder, Bookmarks, Saved Passwords, Extensions" -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan

    Pause-Toolkit

}

function Show-BrowserCleanupMenu {

    do {

        Show-Header "Browser Cleanup"

        Write-Host "1. Google Chrome"
        Write-Host "2. Microsoft Edge"
        Write-Host "3. Clean Both Browsers"
        Write-Host "4. Return to Main Menu"
        Write-Host ""

        $Choice = Read-Host "Enter your choice"

        switch ($Choice) {

            "1" {

                Invoke-ChromeCleanup

            }

            "2" {

                Invoke-EdgeCleanup

            }

            "3" {

                Invoke-ChromeCleanup
                Invoke-EdgeCleanup

            }

            "4" {

                return

            }

            default {

                Write-ErrorMessage "Invalid choice."

                Start-Sleep 2

            }

        }

    }
    while ($Choice -ne "4")

}

function Start-BrowserCleanup {

    Show-BrowserCleanupMenu

}
