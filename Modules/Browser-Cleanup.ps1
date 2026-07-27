# ==============================================================================
# Module: Browser Cleanup
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

function Invoke-ChromeCleanup {

    Show-Header "Google Chrome Cleanup"

    # Check Chrome Installed

    $ChromeInstalled = Test-Path "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" `
        -or Test-Path "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe" `
        -or Test-Path "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"

    if (-not $ChromeInstalled) {

        Write-WarningMessage "Google Chrome is not installed."
        Write-WarningMessage "Nothing to clean."

        Pause-Toolkit
        return

    }

    # Check Running

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

    Write-Info "Cleaning browser data..."

    $UserData = "$env:LOCALAPPDATA\Google\Chrome\User Data"

    foreach ($Profile in Get-ChromeUserProfiles $UserData) {

        Remove-Item "$Profile\History" -Force -ErrorAction SilentlyContinue

        Remove-Item "$Profile\Cookies" -Force -ErrorAction SilentlyContinue

        Remove-Item "$Profile\Network\Cookies" -Force -ErrorAction SilentlyContinue

        @(
            "Cache",
            "Code Cache",
            "GPUCache"
        ) | ForEach-Object {

            $Folder = Join-Path $Profile $_

            if (Test-Path $Folder) {

                Remove-Item "$Folder\*" -Force -Recurse -ErrorAction SilentlyContinue

            }

        }

    }

    Write-Success "Browser cleanup completed."

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Success "Removed"

    Write-Host "✔ Browsing History"
    Write-Host "✔ Cookies"
    Write-Host "✔ Cache"
    Write-Host "✔ Download History"

    Write-Host ""

    Write-Info "Preserved"

    Write-Host "✔ Downloads Folder"
    Write-Host "✔ Bookmarks"
    Write-Host "✔ Saved Passwords"
    Write-Host "✔ Extensions"

    Write-Host ""

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

                Show-Header "Browser Cleanup"

                Write-WarningMessage "Microsoft Edge Cleanup is under development."

                Pause-Toolkit

            }

            "3" {

                Show-Header "Browser Cleanup"

                Write-WarningMessage "Clean Both Browsers is under development."

                Pause-Toolkit

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
