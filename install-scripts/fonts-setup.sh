#!/bin/bash

# Script to install necessary fonts on Fedora

# Create the directory for user-specific fonts if it doesn't exist
mkdir -p ~/.local/share/fonts

# Copy fonts from /assets/fonts to the user fonts directory
cp -r ./assets/fonts/* ~/.local/share/fonts/

# Refresh the font cache
fc-cache -fv

clear
echo "Fonts from /assets/fonts installed successfully!"