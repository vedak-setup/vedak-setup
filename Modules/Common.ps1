function Show-Header {
    param(
        [string]$Title = "Vedak IT Toolkit"
    )

    Clear-Host
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "                    Vedak IT Toolkit" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host $Title -ForegroundColor Yellow
    Write-Host ""
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host ""
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-ErrorMessage {
    param([string]$Message)
    Write-Host ""
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-WarningMessage {
    param([string]$Message)
    Write-Host ""
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Pause-Toolkit {
    Write-Host ""
    Read-Host "Press Enter to return to the Main Menu"
}

function Test-Internet {
    try {
        Invoke-WebRequest -Uri "https://www.google.com" -Method Head -TimeoutSec 5 | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Test-Winget {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($null -eq $winget) {
        return $false
    }
    return $true
}
