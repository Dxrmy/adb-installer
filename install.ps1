Write-Host "Universal ADB Manager" -ForegroundColor Cyan
Write-Host "1. Install ADB"
Write-Host "2. Uninstall ADB"
$choice = Read-Host "Select an option (1/2)"

if ($choice -eq '2') {
    Write-Host "Fetching Windows uninstaller..."
    Invoke-RestMethod "https://raw.githubusercontent.com/Dxrmy/adb-installer/main/uninstall-windows.ps1" | Invoke-Expression
} else {
    Write-Host "Fetching Windows installer..."
    Invoke-RestMethod "https://raw.githubusercontent.com/Dxrmy/adb-installer/main/windows.ps1" | Invoke-Expression
}