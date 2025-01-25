#!/bin/bash

# Script to set up Zsh with Oh My Zsh and developer-focused plugins on Fedora

# Define colors
GREEN="\033[0;32m"
RESET="\033[0m"

sudo dnf install -y zsh util-linux-user

# Set Zsh as the default shell
chsh -s $(which zsh)

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${GREEN}Installing Oh My Zsh...${RESET}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

# Install Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo -e "${GREEN}Installing Zsh plugins...${RESET}"

# Essential plugins
declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
  ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
)

# Developer-focused plugins
plugins+=(
#  ["zsh-docker"]="https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker"
  ["zsh-git"]="https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git"
  ["zsh-npm"]="https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm"
  ["zsh-yarn"]="https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/yarn"
  ["zsh-nvm"]="https://github.com/lukechilds/zsh-nvm"
)

# Install plugins
for plugin in "${!plugins[@]}"; do
  if [ ! -d "${ZSH_CUSTOM}/plugins/$plugin" ]; then
    echo -e "${GREEN}Installing $plugin...${RESET}"
    git clone "${plugins[$plugin]}" "${ZSH_CUSTOM}/plugins/$plugin"
  else
    echo "$plugin is already installed."
  fi
done

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
  echo -e "${GREEN}Installing Powerlevel10k theme...${RESET}"
  git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
fi

# Configure .zshrc
echo -e "${GREEN}Configuring .zshrc...${RESET}"

# Ensure ~/.zshrc exists
if [ ! -f ~/.zshrc ]; then
  touch ~/.zshrc
fi

# Define the new plugins and theme
NEW_PLUGINS="plugins=(
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    npm
    yarn
    nvm
)"
NEW_THEME='ZSH_THEME="powerlevel10k/powerlevel10k"'

# Update the plugins line
if grep -q "^plugins=(" ~/.zshrc; then
  # Replace the existing plugins block in place
  sed -i "/^plugins=(/,/^)/{
    r /dev/stdin
    d
  }" ~/.zshrc <<< "$NEW_PLUGINS"
else
  # Add the plugins line if it doesn't exist
  echo "$NEW_PLUGINS" >> ~/.zshrc
fi

# Uncomment and update the ZSH_THEME line
if grep -q "^#\s*ZSH_THEME=" ~/.zshrc; then
  # Uncomment the line if it's commented out (use | as the delimiter)
  sed -i "s|^#\s*ZSH_THEME=.*|$NEW_THEME|" ~/.zshrc
elif grep -q "^ZSH_THEME=" ~/.zshrc; then
  # Replace the existing ZSH_THEME line (use | as the delimiter)
  sed -i "s|^ZSH_THEME=.*|$NEW_THEME|" ~/.zshrc
else
  # Add the ZSH_THEME line if it doesn't exist
  echo "$NEW_THEME" >> ~/.zshrc
fi

# Apply changes
echo -e "${GREEN}Applying changes...${RESET}"
zsh -c "source ~/.zshrc"


clear