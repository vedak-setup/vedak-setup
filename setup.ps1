Write-Host "=============================="
Write-Host "   Vedak Laptop Setup"
Write-Host "=============================="
Write-Host ""
Write-Host "1. Install Google Chrome"
Write-Host "2. Install Hubstaff"
Write-Host "3. Install Both"
Write-Host "4. Exit"
Write-Host ""

$choice = Read-Host "Enter your choice (1-4)"

if ($choice -eq "1") {

    Write-Host "Installing Google Chrome..."

    winget install --id Google.Chrome -e --silent --accept-package-agreements --accept-source-agreements

    Write-Host "Google Chrome installation completed successfully!"

}

elseif ($choice -eq "2") {

    Write-Host "Installing Hubstaff..."

    winget install --id Hubstaff.Hubstaff -e --silent --accept-package-agreements --accept-source-agreements

    Write-Host "Hubstaff installation completed successfully!"

}

elseif ($choice -eq "3") {

    Write-Host "Installing Google Chrome..."

    winget install --id Google.Chrome -e --silent --accept-package-agreements --accept-source-agreements

    Write-Host "Google Chrome installation completed!"

    Write-Host "Installing Hubstaff..."

    winget install --id Hubstaff.Hubstaff -e --silent --accept-package-agreements --accept-source-agreements

    Write-Host "Hubstaff installation completed!"

}

elseif ($choice -eq "4") {

    Write-Host "Exiting..."
    exit

}

else {

    Write-Host "Invalid choice"

}

Write-Host ""
Write-Host "Vedak setup completed!"
