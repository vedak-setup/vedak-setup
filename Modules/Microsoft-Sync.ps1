#============================================================
# Microsoft-Sync.ps1
# Vedak IT Toolkit
#============================================================

#------------------------------------------------------------
# Load Common Functions
#------------------------------------------------------------
if (-not (Get-Command Show-Header -ErrorAction SilentlyContinue))
{
    $CommonPath = Join-Path $PSScriptRoot "Common.ps1"

    if (Test-Path $CommonPath)
    {
        . $CommonPath
    }
    else
    {
        Write-Host ""
        Write-Host "Common.ps1 not found."
        Write-Host ""
        Read-Host "Press Enter"
        return
    }
}

#------------------------------------------------------------
# Status Helper
#------------------------------------------------------------
function Show-Status
{
    param
    (
        [string]$Message,
        [string]$Status
    )

    switch ($Status)
    {
        "SUCCESS"
        {
            Write-Success $Message
        }

        "FAILED"
        {
            Write-ErrorMessage $Message
        }

        "INFO"
        {
            Write-Info $Message
        }

        "WARNING"
        {
            Write-WarningMessage $Message
        }

        default
        {
            Write-Host $Message
        }
    }
}

#------------------------------------------------------------
# Placeholder Test Functions
#------------------------------------------------------------

function Test-OneDriveAutoStart
{
    return "NOT_IMPLEMENTED"
}

function Test-WindowsBackup
{
    return "NOT_IMPLEMENTED"
}

function Test-EdgeSync
{
    return "NOT_IMPLEMENTED"
}

#------------------------------------------------------------
# Placeholder Action Functions
#------------------------------------------------------------

function Disable-OneDriveAutoStart
{
    return "NOT_IMPLEMENTED"
}

function Disable-WindowsBackup
{
    return "NOT_IMPLEMENTED"
}

function Disable-EdgeSync
{
    return "NOT_IMPLEMENTED"
}

#------------------------------------------------------------
# Run All Settings
#------------------------------------------------------------

function Run-AllMicrosoftSettings
{
    Show-Header "Microsoft Sync"

    Write-Host ""

    Write-Info "Applying Microsoft Settings..."

    Write-Host ""

    Disable-OneDriveAutoStart

    Disable-WindowsBackup

    Disable-EdgeSync

    Write-Host ""

    Write-Success "Completed."

    Pause-Toolkit
}

#------------------------------------------------------------
# Menu
#------------------------------------------------------------

function Show-MicrosoftSyncMenu
{
    do
    {
        Show-Header "Microsoft Sync Configuration"

        Write-Host "1. Turn Off OneDrive Auto Start"
        Write-Host ""
        Write-Host "2. Turn Off Windows Backup"
        Write-Host ""
        Write-Host "3. Turn Off Edge Sync"
        Write-Host ""
        Write-Host "4. Apply All Recommended Settings"
        Write-Host ""
        Write-Host "5. Back"
        Write-Host ""

        $Choice = Read-Host "Select an option"

        switch ($Choice)
        {
            "1"
            {
                Disable-OneDriveAutoStart
            }

            "2"
            {
                Disable-WindowsBackup
            }

            "3"
            {
                Disable-EdgeSync
            }

            "4"
            {
                Run-AllMicrosoftSettings
            }

            "5"
            {
                return
            }

            default
            {
                Write-Host ""
                Write-WarningMessage "Invalid selection."
                Pause-Toolkit
            }
        }

    } while ($true)
}
