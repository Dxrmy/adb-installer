$ErrorActionPreference = 'Stop'
$downloadUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$tempZipPath = "$env:TEMP\platform-tools.zip"
$installDir = "C:\Android"
$adbPath = "$installDir\platform-tools"

Write-Host "Downloading latest ADB for Windows..."
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($downloadUrl, $tempZipPath)

if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir | Out-Null }
if (Test-Path $adbPath) { Remove-Item -Path $adbPath -Recurse -Force }

Write-Host "Extracting..."
Expand-Archive -Path $tempZipPath -DestinationPath $installDir -Force
Remove-Item -Path $tempZipPath -Force

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$adbPath*") {
    $newPath = $userPath
    if (-not $newPath.EndsWith(";")) { $newPath += ";" }
    $newPath += $adbPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Successfully added $adbPath to User PATH."
} else {
    Write-Host "PATH already contains $adbPath."
}

Write-Host "`nInstallation complete! Please restart your terminal session to use 'adb'."