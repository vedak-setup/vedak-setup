# ==============================================================================
# Module: Browser Cleanup (Vedak IT Toolkit v1.0)
# Script Name: BrowserCleanup.ps1
# Description: Performs automated, targeted browser cleanup for IT offboarding/prep.
# ==============================================================================

# ------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------

function Pause-Toolkit {
    Write-Host ""
    Write-Host "Press any key to return to the Browser Cleanup menu..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Get-ChromeUserProfiles {
    param ([string]$UserDataPath)
    
    $profiles = @()
    if (Test-Path $UserDataPath) {
        # 1. Grab Default Profile
        if (Test-Path (Join-Path $UserDataPath "Default")) {
            $profiles += Join-Path $UserDataPath "Default"
        }
        # 2. Grab all extra profiles (Profile 1, Profile 2, etc.)
        $extraProfiles = Get-ChildItem -Path $UserDataPath -Directory -Filter "Profile *" -ErrorAction SilentlyContinue
        foreach ($p in $extraProfiles) {
            $profiles += $p.FullName
        }
    }
    return $profiles
}

# ------------------------------------------------------------------------------
# Core Engine: Google Chrome Cleanup
# ------------------------------------------------------------------------------

function Invoke-ChromeCleanup {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "      Google Chrome Cleanup              " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""

    # STEP 1: Detect whether Chrome is installed
    $chromePath    = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
    $chromePathX86 = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
    $userChromePath = "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"

    if (-not (Test-Path $chromePath) -and -not (Test-Path $chromePathX86) -and -not (Test-Path $userChromePath)) {
        Write-Host "Google Chrome is not installed." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Nothing to clean." -ForegroundColor Yellow
        Write-Host "=========================================" -ForegroundColor Cyan
        Pause-Toolkit
        return
    }

    # STEP 2 & 3: Detect and Close Chrome if running
    $chromeProcess = Get-Process -Name "chrome" -ErrorAction SilentlyContinue
    if ($chromeProcess) {
        Write-Host "Chrome Status : Running" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Closing Google Chrome..." -ForegroundColor Gray
        
        Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        
        Write-Host "Google Chrome Closed Successfully." -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "Chrome Status : Closed" -ForegroundColor Green
        Write-Host ""
    }

    Write-Host "Cleaning Browser Data..." -ForegroundColor Gray
    Write-Host ""

    # STEP 4: Targeted Profile Cleanup (History, Cookies, Cache, Download History)
    $userDataDir = "$env:LOCALAPPDATA\Google\Chrome\User Data"
    $profiles = Get-ChromeUserProfiles -UserDataPath $userDataDir

    foreach ($profile in $profiles) {
        # 1. History & Download History (SQLite 'History' DB file)
        $historyFile = Join-Path $profile "History"
        if (Test-Path $historyFile) { Remove-Item -Path $historyFile -Force -ErrorAction SilentlyContinue }

        # 2. Cookies (Root & Network subfolder)
        $cookiesFile = Join-Path $profile "Cookies"
        $networkCookies = Join-Path $profile "Network\Cookies"
        if (Test-Path $cookiesFile) { Remove-Item -Path $cookiesFile -Force -ErrorAction SilentlyContinue }
        if (Test-Path $networkCookies) { Remove-Item -Path $networkCookies -Force -ErrorAction SilentlyContinue }

        # 3. Cache Directories
        $cacheDirs = @(
            (Join-Path $profile "Cache"),
            (Join-Path $profile "Code Cache"),
            (Join-Path $profile "GPUCache")
        )
        foreach ($dir in $cacheDirs) {
            if (Test-Path $dir) { Remove-Item -Path "$dir\*" -Recurse -Force -ErrorAction SilentlyContinue }
        }
    }

    # STEP 5: Display Success Screen
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "Google Chrome Cleanup Completed Successfully." -ForegroundColor Green
    Write-Host ""
    Write-Host "Removed" -ForegroundColor White
    Write-Host "  [X] Browsing History" -ForegroundColor Green
    Write-Host "  [X] Cookies" -ForegroundColor Green
    Write-Host "  [X] Cache" -ForegroundColor Green
    Write-Host "  [X] Download History" -ForegroundColor Green
    Write-Host ""
    Write-Host "Preserved" -ForegroundColor White
    Write-Host "  [V] Downloads Folder" -ForegroundColor Cyan
    Write-Host "  [V] Bookmarks" -ForegroundColor Cyan
    Write-Host "  [V] Saved Passwords" -ForegroundColor Cyan
    Write-Host "  [V] Extensions" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan

    Pause-Toolkit
}

# ------------------------------------------------------------------------------
# Menu Interface
# ------------------------------------------------------------------------------

function Show-BrowserCleanupMenu {
    do {
        Clear-Host
        Write-Host "=========================================" -ForegroundColor Cyan
        Write-Host "        Browser Cleanup                  " -ForegroundColor Cyan
        Write-Host "=========================================" -ForegroundColor Cyan
        Write-Host "1. Google Chrome"
        Write-Host "2. Microsoft Edge"
        Write-Host "3. Clean Both Browsers"
        Write-Host "4. Return to Main Menu"
        Write-Host "=========================================" -ForegroundColor Cyan
        Write-Host ""
        
        $choice = Read-Host "Enter your choice (1-4)"

        switch ($choice) {
            '1' { Invoke-ChromeCleanup }
            '2' { 
                Clear-Host
                Write-Host "Coming Soon..." -ForegroundColor Yellow
                Pause-Toolkit
            }
            '3' { 
                Clear-Host
                Write-Host "Coming Soon..." -ForegroundColor Yellow
                Pause-Toolkit
            }
            '4' { return }
            default { 
                Write-Host "Invalid choice. Please select 1-4." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    } while ($choice -ne '4')
}

# Execute Menu
Show-BrowserCleanupMenu
