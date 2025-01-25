#!/bin/bash

# Script to install necessary tools for developers on Fedora

# Define colors
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Function to install frontend tools
install_frontend_tools() {
    echo -e "${GREEN}Installing Frontend Developer Tools...${RESET}"

    # Install Node.js, npm, and package managers
    sudo dnf install -y nodejs npm yarn

    # Install nvm (node package manger)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    #Install Node.js with nvm
    nvm install node

    # Install frontend-related tools
    sudo dnf install -y python3-pip
    sudo dnf install -y chromium
    sudo dnf install -y code # Visual Studio Code

    # Frontend development libraries and tools
    sudo dnf install -y gcc-c++ make
    npm install -g @angular/cli @vue/cli create-react-app webpack webpack-cli typescript eslint prettier
}

# Function to install backend tools
install_backend_tools() {
    echo -e "${GREEN}Installing Backend Developer Tools...${RESET}"

    # Install Python, pip, and related packages
    sudo dnf install -y python3 python3-pip
    pip3 install --user flask django fastapi

    # Install Java and related tools
    sudo dnf install -y java-11-openjdk maven gradle

    # Install Docker for backend containers
    sudo dnf install -y docker
    sudo systemctl enable --now docker

    # Install Node.js for backend JavaScript/TypeScript
    sudo dnf install -y nodejs

    # Install database tools
    sudo dnf install -y mysql mysql-server postgresql
}

# Choose development setup
echo -e "${BLUE}Select Development Setup: ${RESET}"
echo -e "${BLUE}1) Frontend Developer${RESET}"
echo -e "${BLUE}2) Backend Developer${RESET}"
echo -e "${BLUE}3) Both Frontend and Backend Developer${RESET}"

read -p "Enter choice (1, 2, or 3): " dev_choice

case $dev_choice in
1)
    install_frontend_tools

    ;;
2)
    install_backend_tools

    ;;
3)
    install_backend_tools
    install_frontend_tools

    ;;
*)
    echo -e "${RED}Invalid choice. Exiting.${RESET}"
    exit 1

    ;;
esac

# Install JetBrains Toolbox if needed
read -p $'\033[0;34mWould you like to install JetBrains Toolbox?\033[0m (y/n): ' jetbrains_choice
if [[ "$jetbrains_choice" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Installing JetBrains Toolbox...${RESET}"
    JETBRAINS_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}' | sed 's/[", ]//g')
    echo $JETBRAINS_URL
    wget $JETBRAINS_URL -O /tmp/jetbrains-toolbox.tar.gz
    tar -xzf jetbrains-toolbox.tar.gz -C /tmp
    /tmp/jetbrains-toolbox-*/jetbrains-toolbox
fi

# Install Postman if needed
read -p $'\033[0;34mWould you like to install Postman?\033[0m (y/n): ' postman_choice
if [[ "$postman_choice" =~ ^[Yy]$ ]]; then
    # Download Postman tarball from the official website
    wget https://dl.pstmn.io/download/latest/linux -O postman.tar.gz

    # Extract the downloaded file
    tar -xvzf postman.tar.gz

    # Move Postman to the appropriate directory
    sudo mv Postman /opt/

    # Create a symbolic link to run Postman easily
    sudo ln -s /opt/Postman/Postman /usr/local/bin/postman

    # Cleanup downloaded tarball
    rm postman.tar.gz

    #  create a desktop shortcut
    cat <<EOF | sudo tee /usr/share/applications/postman.desktop >/dev/null
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF

    chmod +x /usr/share/applications/postman.desktop
fi