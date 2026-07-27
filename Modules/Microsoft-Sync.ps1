<#
.SYNOPSIS
    Vedak IT Toolkit - Microsoft Sync & Removal

.DESCRIPTION
    Disables Microsoft OneDrive synchronization by removing OneDrive
    and disables Microsoft Edge synchronization.
#>

function Remove-OneDrive {

    Show-Header "Disable OneDrive Sync"

    Write-Info "Stopping OneDrive..."

    taskkill /F /IM OneDrive.exe 2>$null | Out-Null

    Stop-Service -Name "OneDrive Updater Service" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "OneDrive Updater Service" -StartupType Disabled -ErrorAction SilentlyContinue

    Write-Info "Removing OneDrive..."

    $Removed = $false

    if (Test-Path "$env:SystemRoot\System32\OneDriveSetup.exe") {
        & "$env:SystemRoot\System32\OneDriveSetup.exe" /uninstall
        $Removed = $true
    }

    if (Test-Path "$env:SystemRoot\SysWOW64\OneDriveSetup.exe") {
        & "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
        $Removed = $true
    }

    Start-Sleep -Seconds 5

    if ($Removed) {
        Write-Success "OneDrive has been disabled successfully."
    }
    else {
        Write-WarningMessage "OneDrive installer not found. It may already be removed."
    }

    Pause-Toolkit
}

function Disable-EdgeSync {

    Show-Header "Disable Edge Sync"

    Write-Info "Applying Microsoft Edge policy..."

    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
        /v SyncDisabled `
        /t REG_DWORD `
        /d 1 `
        /f | Out-Null

    $Policy = Get-ItemProperty `
        -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
        -Name SyncDisabled `
        -ErrorAction SilentlyContinue

    if ($Policy.SyncDisabled -eq 1) {

        Write-Success "Microsoft Edge Sync disabled successfully."

        Write-Info "Closing Microsoft Edge..."

        Stop-Process -Name msedge -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-ErrorMessage "Failed to disable Microsoft Edge Sync."
    }

    Pause-Toolkit
}

function Run-AllMicrosoftSettings {

    Show-Header "Microsoft Sync & Removal"

    Write-Info "Running all Microsoft cleanup tasks..."

    taskkill /F /IM OneDrive.exe 2>$null | Out-Null
    taskkill /F /IM msedge.exe 2>$null | Out-Null

    Stop-Service -Name "OneDrive Updater Service" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "OneDrive Updater Service" -StartupType Disabled -ErrorAction SilentlyContinue

    if (Test-Path "$env:SystemRoot\System32\OneDriveSetup.exe") {
        & "$env:SystemRoot\System32\OneDriveSetup.exe" /uninstall
    }

    if (Test-Path "$env:SystemRoot\SysWOW64\OneDriveSetup.exe") {
        & "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
    }

    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
        /v SyncDisabled `
        /t REG_DWORD `
        /d 1 `
        /f | Out-Null

    Write-Host ""

    Write-Success "All tasks completed successfully."

    Write-Info "Restart the computer once before handing over the laptop."

    Pause-Toolkit
}

function Show-MicrosoftSyncMenu {

    do {

        Show-Header "Microsoft Sync & Removal"

        Write-Host "1. Disable OneDrive Sync"
        Write-Host "2. Disable Edge Sync"
        Write-Host "3. Run All Tasks"
        Write-Host "4. Return to Main Menu"
        Write-Host ""

        $Choice = Read-Host "Enter your choice"

        switch ($Choice) {

            "1" { Remove-OneDrive }

            "2" { Disable-EdgeSync }

            "3" { Run-AllMicrosoftSettings }

            "4" { return }

            default {

                Write-WarningMessage "Invalid selection."

                Pause-Toolkit
            }
        }

    } while ($Choice -ne "4")
}

function Start-MicrosoftSync {

    Show-MicrosoftSyncMenu

}
