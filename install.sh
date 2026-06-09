#!/bin/bash
set -e

echo "Universal ADB Manager"
echo "1. Install ADB"
echo "2. Uninstall ADB"
read -p "Select an option (1/2): " choice

OS="$(uname -s)"

if [ "$choice" = "2" ]; then
    if [ "$OS" = "Darwin" ]; then
        echo "Fetching macOS uninstaller..."
        curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/uninstall-macos.sh | bash
    elif [ "$OS" = "Linux" ]; then
        echo "Fetching Linux uninstaller..."
        curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/uninstall-linux.sh | bash
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
else
    if [ "$OS" = "Darwin" ]; then
        echo "Fetching macOS installer..."
        curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/macos.sh | bash
    elif [ "$OS" = "Linux" ]; then
        echo "Fetching Linux installer..."
        curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/linux.sh | bash
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
fi