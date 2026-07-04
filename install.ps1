$ErrorActionPreference = "Stop"

$installDir = Join-Path $HOME ".adb"
$binDir = Join-Path $installDir "platform-tools"

function Show-CatHeader {
    Clear-Host
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $b64 = "ICDilbF844CBICAgICAgIG1lb3cuCijLmsuOIOOAgjcgICAgIC8KIHzjgIHLnOOAtSAgICAgICAgICAKIOOBmOOBl8uNLCnjg44="
    $cat = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b64))
    Write-Host ""
    Write-Host $cat -ForegroundColor Magenta
    Write-Host ""
    Write-Host "       Universal ADB Manager" -ForegroundColor Cyan
    Write-Host ""
}

function Invoke-FastDownload {
    param([string]$Url, [string]$OutFile)
    
    try {
        $request = [System.Net.WebRequest]::Create($Url)
        $response = $request.GetResponse()
        $totalLength = $response.ContentLength
        $responseStream = $response.GetResponseStream()
        $targetStream = [System.IO.File]::Create($OutFile)
        $buffer = New-Object byte[] 65536
        $count = 0
        $downloaded = 0
        
        do {
            $count = $responseStream.Read($buffer, 0, $buffer.Length)
            if ($count -gt 0) {
                $targetStream.Write($buffer, 0, $count)
                $downloaded += $count
                if ($totalLength -gt 0) {
                    $percent = [math]::Round(($downloaded / $totalLength) * 100)
                    Write-Progress -Activity "Downloading Platform Tools" -Status "$percent% Complete" -PercentComplete $percent -Id 1
                }
            }
        } while ($count -gt 0)
    } finally {
        if ($targetStream) { $targetStream.Dispose() }
        if ($responseStream) { $responseStream.Dispose() }
        if ($response) { $response.Close() }
    }
    Write-Progress -Activity "Downloading Platform Tools" -Completed -Id 1
}

function Install-Adb {
    if ($IsMacOS) {
        $url = "https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
    } elseif ($IsLinux) {
        $url = "https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
    } else {
        $url = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
    }
    
    $zipPath = Join-Path $HOME "platform-tools.zip"

    Write-Host " [*] Preparing installation directory..." -ForegroundColor Yellow
    if (Test-Path $installDir) { Remove-Item -Path $installDir -Recurse -Force }
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null

    Write-Host " [*] Downloading ADB from Google..." -ForegroundColor Yellow
    Invoke-FastDownload -Url $url -OutFile $zipPath

    Write-Host " [*] Extracting files..." -ForegroundColor Yellow
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
    } catch {}
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $installDir)

    Write-Host " [*] Cleaning up..." -ForegroundColor Yellow
    Remove-Item -Path $zipPath -Force

    Write-Host " [*] Adding to system PATH..." -ForegroundColor Yellow
    if ($PSVersionTable.PSEdition -ne "Core" -or $IsWindows) {
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($userPath -notmatch [regex]::Escape($binDir)) {
            [Environment]::SetEnvironmentVariable("PATH", "$userPath;$binDir", "User")
        }
    } else {
        $exportLine = "`nexport PATH=`"`$PATH:$binDir`""
        foreach ($profile in @("$HOME/.bashrc", "$HOME/.zshrc")) {
            if (Test-Path $profile) {
                $content = Get-Content $profile -Raw
                if ($content -notmatch [regex]::Escape($binDir)) {
                    Add-Content -Path $profile -Value $exportLine
                }
            }
        }
        $adbExe = Join-Path $binDir "adb"
        if (Test-Path $adbExe) { bash -c "chmod +x '$adbExe'" }
    }

    Write-Host " [v] Successfully installed ADB!" -ForegroundColor Green
    Write-Host "     Please restart your terminal to use 'adb'." -ForegroundColor Gray
}

function Uninstall-Adb {
    Write-Host " [*] Removing ADB files..." -ForegroundColor Yellow
    if (Test-Path $installDir) {
        Remove-Item -Path $installDir -Recurse -Force
    }

    Write-Host " [*] Removing from system PATH..." -ForegroundColor Yellow
    if ($PSVersionTable.PSEdition -ne "Core" -or $IsWindows) {
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($userPath) {
            $newPath = ($userPath -split ';' | Where-Object { $_ -ne $binDir -and $_ -ne "" }) -join ';'
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        }
    } else {
        Write-Host "     Please manually remove $binDir from your .bashrc or .zshrc" -ForegroundColor Gray
    }

    Write-Host " [v] Successfully uninstalled ADB!" -ForegroundColor Green
}

Show-CatHeader

Write-Host " 1. Install ADB" -ForegroundColor White
Write-Host " 2. Uninstall ADB" -ForegroundColor White
Write-Host ""
$choice = Read-Host " Select an option (1/2)"

Write-Host ""
if ($choice -eq '1') {
    Install-Adb
} elseif ($choice -eq '2') {
    Uninstall-Adb
} else {
    Write-Host " [x] Invalid option selected." -ForegroundColor Red
}
