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

    $Chrome = winget list --id Google.Chrome --exact 2>$null

    if ($Chrome -match "Google.Chrome") {

        Write-Success "Google Chrome is already installed."

        Pause-Toolkit
        return

    }

    Write-Info "Installing Google Chrome..."
    Write-Host ""

    try {

        winget install --id Google.Chrome --exact --silent --accept-package-agreements --accept-source-agreements

        if ($LASTEXITCODE -eq 0) {

            Write-Success "Google Chrome installed successfully."

        }
        else {

            Write-ErrorMessage "Google Chrome installation failed."

        }

    }
    catch {

        Write-ErrorMessage $_.Exception.Message

    }

    Pause-Toolkit

}
