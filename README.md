# ADB Installer

Here is a quick script to download and install ADB.

**Windows:**
```powershell
irm https://raw.githubusercontent.com/Dxrmy/adb-installer/main/install.ps1 | iex
```

**macOS & Linux:**
```bash
curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/install.sh | bash
```

## Usage

### Running ADB

Once installed, you can start using ADB from your terminal:

1. Connect your Android device to your computer via USB.
2. Ensure **USB Debugging** is enabled in your device's Developer Options.
3. Open a new terminal or command prompt (you may need to restart it if you just installed ADB).
4. Run the following command to see your connected devices:

```bash
adb devices
```

### Uninstalling

If you want to uninstall ADB later, simply run the installation command again and select the **Uninstall** option (`2`) from the interactive menu.
