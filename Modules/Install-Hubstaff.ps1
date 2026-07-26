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

    $Hubstaff = winget list --id Netsoft.Hubstaff --exact 2>$null

    if ($Hubstaff -match "Netsoft.Hubstaff") {

        Write-Success "Hubstaff is already installed."

        Pause-Toolkit
        return

    }

    Write-Info "Installing Hubstaff..."
    Write-Host ""

    try {

        winget install --id Netsoft.Hubstaff --exact --silent --accept-package-agreements --accept-source-agreements

        if ($LASTEXITCODE -eq 0) {

            Write-Success "Hubstaff installed successfully."

        }
        else {

            Write-ErrorMessage "Hubstaff installation failed."

        }

    }
    catch {

        Write-ErrorMessage $_.Exception.Message

    }

    Pause-Toolkit

}
