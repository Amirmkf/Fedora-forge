#!/bin/bash

# Script to set up Gnome extentions on Fedora

# Define colors
GREEN="\033[0;32m"
RESET="\033[0m"

sudo dnf install gnome-tweaks

# Install Extension Manager
flatpak install flathub com.mattjakeman.ExtensionManager

# Add Minimize and Maximize buttons to window
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# Function to install an extension
install_extension() {
    EXTENSION_UUID=$1
    EXTENSION_VERSION=$2

    # Construct the download URL
    DOWNLOAD_URL="https://extensions.gnome.org/extension-data/${EXTENSION_UUID}.v${EXTENSION_VERSION}.shell-extension.zip"

    echo "Installing extension: $EXTENSION_UUID (Version: $EXTENSION_VERSION)"

    # Download the extension zip
    wget -q -O "/tmp/${EXTENSION_UUID}.zip" "$DOWNLOAD_URL"

    # Install the extension
    gnome-extensions install "/tmp/${EXTENSION_UUID}.zip"

    # Clean up temporary files
    rm -rf "/tmp/${EXTENSION_UUID}.zip"
}

# List of extensions to install
# Format: "UUID VERSION"
EXTENSIONS=(
"caffeinepatapon.info 55"
"appindicatorsupportrgcjonas.gmail.com 59"
"clipboard-indicatortudmotu.com 65"
"blur-my-shellaunetx 67"
"compiz-windows-effecthermes83.github.com 25"
"compiz-alike-magic-lamp-effecthermes83.github.com 20"
"dash-to-dockmicxgx.gmail.com 99"
"gsconnectandyholmes.github.io 58"
"tilingshellferrarodomenico.com 48"
"VitalsCoreCoding.com 70"
)

# Iterate through the extensions list
for EXTENSION in "${EXTENSIONS[@]}"; do
    install_extension $EXTENSION
done

clear
echo -e "${GREEN}All extensions installed and enabled!${RESET}"
