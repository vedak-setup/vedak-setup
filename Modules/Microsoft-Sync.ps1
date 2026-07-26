# Microsoft-Sync.ps1
# Vedak IT Toolkit
# NOTE:
# This is a scaffold module intended to integrate with the existing toolkit.
# Windows Backup and Edge Sync do not have a single reliable supported
# automation method on Windows 11 Home with personal Microsoft accounts.
# The functions below therefore automate OneDrive where supported and
# clearly report when an action cannot be completed automatically.

function Test-OneDriveAutoStart {
    $run = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue
    if (-not $run) { return "NOT_CONFIGURED" }

    if ($run.OneDrive) {
        return "ENABLED"
    }

    return "DISABLED"
}

function Disable-OneDriveAutoStart {

    Show-Header "Microsoft Sync"

    Write-Info "Turning Off OneDrive Auto Start..."

    try {
        Remove-ItemProperty `
            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
            -Name "OneDrive" `
            -ErrorAction SilentlyContinue

        Get-Process OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force

        $state = Test-OneDriveAutoStart

        if ($state -eq "DISABLED") {
            Write-Success "OneDrive Auto Start Disabled."
        }
        else {
            Write-WarningMessage "Unable to verify OneDrive Auto Start."
        }
    }
    catch {
        Write-ErrorMessage $_.Exception.Message
    }

    Pause-Toolkit
}

function Test-WindowsBackup {
    return "MANUAL_REQUIRED"
}

function Disable-WindowsBackup {

    Show-Header "Microsoft Sync"

    Write-Info "Turning Off Windows Backup..."

    Write-WarningMessage "Windows Backup cannot be reliably disabled automatically on this Windows configuration."

    try {
        Start-Process "ms-settings:windowsbackup"
    } catch {}

    Pause-Toolkit
}

function Test-EdgeSync {
    return "MANUAL_REQUIRED"
}

function Disable-EdgeSync {

    Show-Header "Microsoft Sync"

    Write-Info "Turning Off Edge Sync..."

    try {
        Start-Process "microsoft-edge://settings/profiles/sync"
    }
    catch {
        try {
            Start-Process "msedge.exe"
        } catch {}
    }

    Write-WarningMessage "Edge Sync must be turned off manually."

    Pause-Toolkit
}

function Run-AllMicrosoftSettings {

    Disable-OneDriveAutoStart
    Disable-WindowsBackup
    Disable-EdgeSync

    Show-Header "Microsoft Sync"

    Write-Success "Completed."

    Pause-Toolkit
}

function Show-MicrosoftSyncMenu {

    do {

        Show-Header "Microsoft Sync Configuration"

        Write-Host "1. Turn Off OneDrive Auto Start"
        Write-Host "2. Turn Off Windows Backup"
        Write-Host "3. Turn Off Edge Sync"
        Write-Host "4. Apply All Recommended Settings"
        Write-Host "5. Back"
        Write-Host ""

        $Choice = Read-Host "Enter your choice"

        switch ($Choice) {

            "1" { Disable-OneDriveAutoStart }

            "2" { Disable-WindowsBackup }

            "3" { Disable-EdgeSync }

            "4" { Run-AllMicrosoftSettings }

            "5" { return }

            default {
                Write-WarningMessage "Invalid selection."
                Pause-Toolkit
            }
        }

    } while ($true)
}

function Start-MicrosoftSync {
    Show-MicrosoftSyncMenu
}
