#!/bin/bash
set -e

OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS host..."
    curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/macos.sh | bash
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux host..."
    curl -sL https://raw.githubusercontent.com/Dxrmy/adb-installer/main/linux.sh | bash
else
    echo "Unsupported OS: $OS"
    exit 1
fi