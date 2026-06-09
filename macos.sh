#!/bin/bash
set -e

echo "Downloading latest ADB for macOS..."
URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
TEMP_ZIP="/tmp/platform-tools.zip"
INSTALL_DIR="$HOME/Library/Android"
ADB_PATH="$INSTALL_DIR/platform-tools"

curl -sL $URL -o $TEMP_ZIP
mkdir -p "$INSTALL_DIR"
rm -rf "$ADB_PATH"

echo "Extracting..."
unzip -q $TEMP_ZIP -d "$INSTALL_DIR"
rm $TEMP_ZIP

# Add to path based on common macOS shell configs
RC_FILE="$HOME/.zprofile"
if [ -f "$HOME/.zshrc" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    RC_FILE="$HOME/.bash_profile"
fi

if ! grep -q "$ADB_PATH" "$RC_FILE" 2>/dev/null; then
    echo "" >> "$RC_FILE"
    echo "export PATH=\"\$PATH:$ADB_PATH\"" >> "$RC_FILE"
    echo "Added $ADB_PATH to PATH in $RC_FILE"
else
    echo "PATH already contains $ADB_PATH in $RC_FILE"
fi

echo -e "\nInstallation complete! Run 'source $RC_FILE' or restart your terminal to use 'adb'."