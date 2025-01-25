#!/bin/bash

# Script to install ROG drivers on Fedora

# Define colors for output messages
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Install kernel development packages
sudo dnf install kernel-devel

# Enable the ASUS Linux COPR repository
sudo dnf copr enable lukenukem/asus-linux

# Update the system to ensure all packages are up-to-date
sudo dnf update

# Install ASUS tools and utilities:
sudo dnf install asusctl supergfxctl

# Refresh package metadata and update packages again to ensure consistency
sudo dnf update --refresh

# Enable the supergfxd service
sudo systemctl enable supergfxd.service

# Install the GUI for ASUS ROG Control (optional)
sudo dnf install asusctl-rog-gui

clear