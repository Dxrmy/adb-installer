#!/bin/bash
set -e

INSTALL_DIR="$HOME/Library/Android"
ADB_PATH="$INSTALL_DIR/platform-tools"

if [ -d "$ADB_PATH" ]; then
    echo "Removing $ADB_PATH..."
    rm -rf "$ADB_PATH"
else
    echo "ADB directory not found at $ADB_PATH."
fi

RC_FILES=("$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.bash_profile")
for RC_FILE in "${RC_FILES[@]}"; do
    if [ -f "$RC_FILE" ]; then
        if grep -q "export PATH=\"\$PATH:$ADB_PATH\"" "$RC_FILE"; then
            echo "Removing ADB from $RC_FILE..."
            sed -i '' "\|export PATH=\"\$PATH:$ADB_PATH\"|d" "$RC_FILE"
        fi
    fi
done

echo -e "\nUninstallation complete! Please restart your terminal."