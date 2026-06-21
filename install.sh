#!/bin/bash
set -e

# Cat ASCII Art
echo -e "\e[35m  ╱|、       meow.\e[0m"
echo -e "\e[35m(˚ˎ 。7     /\e[0m"
echo -e "\e[35m |、˜〵          \e[0m"
echo -e "\e[35m じしˍ,)ノ\e[0m"
echo ""
echo -e "\e[36m Universal ADB Manager\e[0m"
echo ""

install_adb() {
    INSTALL_DIR="$HOME/.adb"
    BIN_DIR="$INSTALL_DIR/platform-tools"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
    else
        URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
    fi
    
    ZIP_PATH="$HOME/platform-tools.zip"

    echo -e "\e[33m [*] Preparing installation directory...\e[0m"
    rm -rf "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"

    echo -e "\e[33m [*] Downloading ADB from Google...\e[0m"
    curl -L --progress-bar "$URL" -o "$ZIP_PATH"

    echo -e "\e[33m [*] Extracting files...\e[0m"
    # Fallback to python extraction if unzip is missing
    if command -v unzip >/dev/null 2>&1; then
        unzip -q "$ZIP_PATH" -d "$INSTALL_DIR"
    else
        python3 -m zipfile -e "$ZIP_PATH" "$INSTALL_DIR"
    fi

    echo -e "\e[33m [*] Cleaning up...\e[0m"
    rm -f "$ZIP_PATH"

    echo -e "\e[33m [*] Adding to system PATH...\e[0m"
    EXPORT_LINE="\nexport PATH=\"\$PATH:$BIN_DIR\""
    
    for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile"; do
        if [ -f "$profile" ]; then
            if ! grep -Fq "$BIN_DIR" "$profile"; then
                echo -e "$EXPORT_LINE" >> "$profile"
            fi
        fi
    done
    
    if [ -f "$BIN_DIR/adb" ]; then
        chmod +x "$BIN_DIR/adb"
    fi

    echo -e "\e[32m [v] Successfully installed ADB!\e[0m"
    echo -e "\e[90m     Please restart your terminal to use 'adb'.\e[0m"
}

uninstall_adb() {
    INSTALL_DIR="$HOME/.adb"
    BIN_DIR="$INSTALL_DIR/platform-tools"

    echo -e "\e[33m [*] Removing ADB files...\e[0m"
    rm -rf "$INSTALL_DIR"

    echo -e "\e[33m [*] Removing from system PATH...\e[0m"
    echo -e "\e[90m     Please manually remove $BIN_DIR from your .bashrc or .zshrc\e[0m"

    echo -e "\e[32m [v] Successfully uninstalled ADB!\e[0m"
}

echo -e "\e[37m 1. Install ADB\e[0m"
echo -e "\e[37m 2. Uninstall ADB\e[0m"
echo ""
read -p " Select an option (1/2): " choice

echo ""
if [ "$choice" == "1" ]; then
    install_adb
elif [ "$choice" == "2" ]; then
    uninstall_adb
else
    echo -e "\e[31m [x] Invalid option selected.\e[0m"
fi
