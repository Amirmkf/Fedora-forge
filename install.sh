#!/bin/bash

# Define colors
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
RESET="\033[0m"

echo -e "${GREEN}Starting Fedora post-installation setup...${RESET}"

# Update and upgrade system
echo -e "${GREEN}Updating system...${RESET}"
sudo dnf upgrade --refresh -y

echo -e "${GREEN}Starting setup to optimize DNF and manage old kernels on Fedora...${RESET}"
bash ./install-scripts/dnf-optimize.sh

# Enable RPM Fusion
echo -e "${GREEN}Enabling RPM Fusion repositories...${RESET}"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Enable Flatpak support
echo -e "${GREEN}Setting up Flatpak support...${RESET}"
sudo dnf install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo dnf install git curl wget vim

# Install zsh and Oh my zsh
echo -e "${GREEN}Setting up fonts...${RESET}"
bash ./install-scripts/fonts-setup.sh

# Install Gnome extentions
echo -e "${GREEN}Setting up Gnome extentions...${RESET}"
bash ./install-scripts/gnome-setup.sh

# Install Gnome extentions
echo -e "${GREEN}Installing NVIDIA drivers...${RESET}"
bash ./install-scripts/nvidia-setup.sh

# Install ROG drivers
read -p $'\033[0;34mYou have a ROG laptop?\033[0m (y/n): ' install_rog
if [[ "$install_rog" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Installing ROG drivers and tools...${RESET}"
    bash ./install-scripts/rog-setup.sh
fi

# Install Developer tools
read -p $'\033[0;34mAre You a developer?\033[0m (y/n): ' is_developer
if [[ "$is_developer" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Installing developer tools...${RESET}"
        bash ./install-scripts/developer-setup.sh
fi

# Install some useful apps
echo -e "${GREEN}Installing some useful apps...${RESET}"
bash ./install-scripts/apps-install.sh

sudo dnf upgrade --refresh -y

# Install zsh and Oh my zsh
echo -e "${GREEN}Setting up Zsh and plugins...${RESET}"
bash ./install-scripts/zsh-setup.sh

echo -e "${BLUE}Reboot your system to apply all changes.${RESET}"
