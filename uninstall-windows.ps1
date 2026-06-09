$ErrorActionPreference = 'SilentlyContinue'

$installDir = "C:\Android"
$adbPath = "$installDir\platform-tools"

if (Test-Path $adbPath) {
    Write-Host "Removing $adbPath..."
    Remove-Item -Path $adbPath -Recurse -Force
} else {
    Write-Host "ADB directory not found at $adbPath."
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -match [regex]::Escape($adbPath)) {
    Write-Host "Removing ADB from User PATH..."
    $paths = $userPath -split ';' | Where-Object { $_ -ne $adbPath -and $_ -ne "" }
    $newPath = $paths -join ';'
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Successfully cleaned up PATH."
}

Write-Host "`nUninstallation complete! Please restart your terminal session."