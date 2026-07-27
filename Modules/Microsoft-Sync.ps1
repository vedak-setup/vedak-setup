# ==============================================================================
# Module: Microsoft Sync Configuration
# Script Name: Microsoft-Sync.ps1
# Description: Configures Microsoft Edge Sync and launches OneDrive Sync
# ==============================================================================

function Start-MicrosoftSync {

    Show-Header "Microsoft Sync Configuration"

    Write-Info "Checking Microsoft Edge status..."

    # Close Edge if it is currently running to apply policy changes safely
    $EdgeProcess = Get-Process msedge -ErrorAction SilentlyContinue

    if ($EdgeProcess) {
        Write-Info "Closing Microsoft Edge..."
        Stop-Process -Name msedge -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Success "Microsoft Edge closed successfully."
    }

    Write-Host ""
    Write-Info "Applying Microsoft Edge Sync Policies..."

    try {
        # Enable Edge Browser Sync via Registry
        $EdgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

        if (-not (Test-Path $EdgePolicyPath)) {
            New-Item -Path $EdgePolicyPath -Force | Out-Null
        }

        # Force Sync enable in Edge
        Set-ItemProperty -Path $EdgePolicyPath -Name "SyncDisabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        
        # Enable implicit sign-in with Windows account
        Set-ItemProperty -Path $EdgePolicyPath -Name "ImplicitSignInEnabled" -Value 1 -Type DWord -ErrorAction SilentlyContinue

        Write-Success "Edge Sync registry policies applied successfully."
    }
    catch {
        Write-ErrorMessage "Failed to apply Edge Sync registry settings."
        Write-ErrorMessage $_.Exception.Message
    }

    Write-Host ""
    Write-Info "Checking OneDrive Sync Client..."

    # Trigger OneDrive executable if installed
    $OneDrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
    $OneDriveSysPath = "${env:ProgramFiles}\Microsoft OneDrive\OneDrive.exe"

    if (Test-Path $OneDrivePath) {
        Start-Process -FilePath $OneDrivePath -ErrorAction SilentlyContinue
        Write-Success "OneDrive user sync agent launched."
    }
    elseif (Test-Path $OneDriveSysPath) {
        Start-Process -FilePath $OneDriveSysPath -ErrorAction SilentlyContinue
        Write-Success "OneDrive system sync agent launched."
    }
    else {
        Write-WarningMessage "OneDrive executable was not found on this system."
    }

    Write-Host ""
    Write-Success "Microsoft Sync configuration completed."

    Pause-Toolkit

}
