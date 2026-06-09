Write-Host "Detected Windows host..."
Invoke-RestMethod "https://raw.githubusercontent.com/Dxrmy/adb-installer/main/windows.ps1" | Invoke-Expression