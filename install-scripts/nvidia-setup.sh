#!/bin/bash

# Script to install nvidia drivers on Fedora

# Define colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RESET="\033[0m"

dnf install -y akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-power

echo -e "${GREEN}Installing Vulkan support for NVIDIA...${RESET}"
dnf install -y vulkan vulkan-tools xorg-x11-drv-nvidia-cuda-libs


echo e "${GREEN}Ensuring NVIDIA drivers are set up for CUDA development...${RESET}"
dnf install -y nvidia-settings nvidia-modprobe nvidia-xconfig

sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-powerd.service
#echo -e "${BLUE}Verifying installation...${RESET}"
#nvidia-smi

clear