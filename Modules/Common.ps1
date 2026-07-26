function Show-Header {
    param(
        [string]$Title = ""
    )

    Clear-Host

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "                    Vedak IT Toolkit" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    if (-not [string]::IsNullOrWhiteSpace($Title)) {
        Write-Host $Title -ForegroundColor Yellow
        Write-Host ""
    }
}

function Write-Info {
    param(
        [string]$Message
    )

    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param(
        [string]$Message
    )

    Write-Host ""
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-ErrorMessage {
    param(
        [string]$Message
    )

    Write-Host ""
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-WarningMessage {
    param(
        [string]$Message
    )

    Write-Host ""
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Pause-Toolkit {

    Write-Host ""
    Read-Host "Press Enter to return to the Main Menu"

}

function Test-Internet {

    try {

        $client = New-Object System.Net.Sockets.TcpClient

        $result = $client.BeginConnect("8.8.8.8",53,$null,$null)

        $success = $result.AsyncWaitHandle.WaitOne(3000,$false)

        $client.Close()

        return $success

    }
    catch {

        return $false

    }

}

function Test-Winget {

    $Winget = Get-Command winget -ErrorAction SilentlyContinue

    if ($null -eq $Winget) {
        return $false
    }

    return $true

}
