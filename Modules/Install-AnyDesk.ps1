function Install-AnyDesk {

    Show-Header "AnyDesk Installation"

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

    $AnyDesk = winget list --id AnyDesk.AnyDesk --exact 2>$null

    if ($AnyDesk -match "AnyDesk.AnyDesk") {

        Write-Success "AnyDesk is already installed."

        Pause-Toolkit
        return

    }

    Write-Info "Installing AnyDesk..."
    Write-Host ""

    try {

        winget install --id AnyDesk.AnyDesk --exact --silent --accept-package-agreements --accept-source-agreements

        if ($LASTEXITCODE -eq 0) {

            Write-Success "AnyDesk installed successfully."

        }
        else {

            Write-ErrorMessage "AnyDesk installation failed."

        }

    }
    catch {

        Write-ErrorMessage $_.Exception.Message

    }

    Pause-Toolkit

}
