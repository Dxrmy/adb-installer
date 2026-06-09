#!/bin/bash
set -e

echo "Downloading latest ADB for Linux..."
URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
TEMP_ZIP="/tmp/platform-tools.zip"
INSTALL_DIR="$HOME/.local/share/android"
ADB_PATH="$INSTALL_DIR/platform-tools"

curl -sL $URL -o $TEMP_ZIP
mkdir -p "$INSTALL_DIR"
rm -rf "$ADB_PATH"

echo "Extracting..."
unzip -q $TEMP_ZIP -d "$INSTALL_DIR"
rm $TEMP_ZIP

RC_FILE="$HOME/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
    RC_FILE="$HOME/.zshrc"
fi

if ! grep -q "$ADB_PATH" "$RC_FILE"; then
    echo "" >> "$RC_FILE"
    echo "export PATH=\"\$PATH:$ADB_PATH\"" >> "$RC_FILE"
    echo "Added $ADB_PATH to PATH in $RC_FILE"
else
    echo "PATH already contains $ADB_PATH in $RC_FILE"
fi

echo -e "\nInstallation complete! Run 'source $RC_FILE' or restart your terminal to use 'adb'."