# Universal ADB Installer

Automatically downloads and installs the latest Android Debug Bridge (ADB) and Fastboot binaries directly from Google, and adds them to your system's PATH.

Works cleanly without needing any prior software or package managers installed.

## Installation

### Windows
Open **PowerShell** and run the following command:
```powershell
irm https://raw.githubusercontent.com/Dxrmy/adb-installer/main/install.ps1 | iex
```

### macOS & Linux
Open your **Terminal** and run the following command:
```bash
curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/install.sh | bash
```

## What this does
1. Detects your OS and processor architecture
2. Downloads the official `platform-tools` ZIP directly from Google's repository
3. Extracts it to a safe, hidden location (`C:\Android\` on Windows, `~/.local/share/android/` on Linux, `~/Library/Android/` on macOS)
4. Adds the folder to your `PATH` so `adb` and `fastboot` commands work globally
