
function Install-Hubstaff {

    Show-Header "Hubstaff Installation"

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

    Write-Info "Checking Hubstaff installation..."
    Write-Host ""

    try {

        winget list --id Netsoft.Hubstaff --exact --accept-source-agreements 2>$null | Out-Null
        $ListExitCode = $LASTEXITCODE

        if ($ListExitCode -eq 0) {

            Write-Info "Hubstaff already exists. Checking for updates..."
            $Action = "upgrade"

        }
        else {

            Write-Info "Hubstaff is not installed. Starting installation..."
            $Action = "install"

        }

        Write-Host ""

        if ($Action -eq "upgrade") {

            winget upgrade --id Netsoft.Hubstaff --exact --silent --accept-package-agreements --accept-source-agreements

        }
        else {

            winget install --id Netsoft.Hubstaff --exact --silent --accept-package-agreements --accept-source-agreements

        }

        $InstallExitCode = $LASTEXITCODE

        if ($InstallExitCode -eq 0) {

            Write-Success "Hubstaff operation completed successfully."

        }
        elseif ($InstallExitCode -eq -1978335189) {

            Write-Success "Hubstaff is already up to date."

        }
        else {

            Write-ErrorMessage "Hubstaff operation failed. Winget exit code: $InstallExitCode"

        }

    }
    catch {

        Write-ErrorMessage "Hubstaff error: $($_.Exception.Message)"

    }

    Pause-Toolkit

}
