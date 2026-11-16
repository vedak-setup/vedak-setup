
function Install-Chrome {

    Show-Header "Google Chrome Installation"

    if (-not (Test-Internet)) {
        Write-ErrorMessage "Internet connection is not available."
        Pause-Toolkit
        return
    }

    if (-not (Test-Winget)) {
        Write-ErrorMessage "Winget is not installed or unavailable."
        Pause-Toolkit
        return
    }

    Write-Info "Checking Google Chrome installation..."
    Write-Host ""

    try {

        winget list --id Google.Chrome --exact --accept-source-agreements 2>$null | Out-Null
        $ListExitCode = $LASTEXITCODE

        if ($ListExitCode -eq 0) {
            Write-Info "Google Chrome already exists. Checking for updates..."
            $Action = "upgrade"
        }
        else {
            Write-Info "Google Chrome is not installed. Starting installation..."
            $Action = "install"
        }

        Write-Host ""

        if ($Action -eq "upgrade") {

            winget upgrade --id Google.Chrome --exact --silent --accept-package-agreements --accept-source-agreements

        }
        else {

            winget install --id Google.Chrome --exact --silent --accept-package-agreements --accept-source-agreements

        }

        $InstallExitCode = $LASTEXITCODE

        if ($InstallExitCode -eq 0) {
            Write-Success "Google Chrome operation completed successfully."
        }
        elseif ($InstallExitCode -eq -1978335189) {
            Write-Success "Google Chrome is already up to date."
        }
        else {
            Write-ErrorMessage "Google Chrome operation failed. Winget exit code: $InstallExitCode"
        }

    }
    catch {

        Write-ErrorMessage "Google Chrome error: $($_.Exception.Message)"

    }

    Pause-Toolkit

}
