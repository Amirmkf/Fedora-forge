#!/bin/bash

# Script to optimize DNF and configure Fedora to manage old kernels automatically

# Define colors
GREEN="\033[0;32m"
RESET="\033[0m"

# Prompt user for installonly_limit value
read -p $'\033[0;34mEnter the number of kernels to keep\033[0m (default is 3): ' kernel_limit
kernel_limit=${kernel_limit:-3} # Default to 3 if no input is provided

# Optimize DNF in /etc/dnf/dnf.conf
echo "Configuring DNF in /etc/dnf/dnf.conf with installonly_limit=${kernel_limit}..."
sudo sed -i '/^fastestmirror=/d' /etc/dnf/dnf.conf
sudo sed -i '/^max_parallel_downloads=/d' /etc/dnf/dnf.conf
#sudo sed -i '/^metadata_expire=/d' /etc/dnf/dnf.conf
#sudo sed -i '/^defaultyes=/d' /etc/dnf/dnf.conf
#sudo sed -i '/^keepcache=/d' /etc/dnf/dnf.conf
sudo sed -i '/^installonly_limit=/d' /etc/dnf/dnf.conf

cat <<EOF | sudo tee -a /etc/dnf/dnf.conf
fastestmirror=True
max_parallel_downloads=10
installonly_limit=${kernel_limit}
EOF

clear

echo -e "${GREEN}Setup completed! DNF is optimized, and old kernels will be managed automatically.${RESET}"