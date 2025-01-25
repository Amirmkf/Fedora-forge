#!/bin/bash

# Script to set up Zsh with Oh My Zsh and developer-focused plugins on Fedora

# Define colors
GREEN="\033[0;32m"
RESET="\033[0m"

# Install Zsh and required utilities
echo -e "${GREEN}Installing Zsh and required utilities...${RESET}"
sudo dnf install -y zsh util-linux-user

# Set Zsh as the default shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo -e "${GREEN}Setting Zsh as the default shell...${RESET}"
  chsh -s "$(which zsh)"
else
  echo "Zsh is already the default shell."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${GREEN}Installing Oh My Zsh...${RESET}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    echo "Failed to install Oh My Zsh. Exiting."
    exit 1
  }
else
  echo "Oh My Zsh is already installed."
fi

# Install Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo -e "${GREEN}Installing Zsh plugins...${RESET}"

declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
  ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
  ["zsh-nvm"]="https://github.com/lukechilds/zsh-nvm"
)

for plugin in "${!plugins[@]}"; do
  if [ ! -d "${ZSH_CUSTOM}/plugins/$plugin" ]; then
    echo -e "${GREEN}Installing $plugin...${RESET}"
    git clone "${plugins[$plugin]}" "${ZSH_CUSTOM}/plugins/$plugin" || {
      echo "Failed to install $plugin."
    }
  else
    echo "$plugin is already installed."
  fi
done

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
  echo -e "${GREEN}Installing Powerlevel10k theme...${RESET}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k" || {
    echo "Failed to install Powerlevel10k theme."
  }
else
  echo "Powerlevel10k theme is already installed."
fi

# Configure .zshrc
echo -e "${GREEN}Configuring .zshrc...${RESET}"

# Ensure ~/.zshrc exists
if [ ! -f ~/.zshrc ]; then
  echo "Creating .zshrc..."
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
SOURCE_LINE="source \$ZSH/oh-my-zsh.sh"

# Update the plugins line
if grep -q "^plugins=(" ~/.zshrc; then
  sed -i "/^plugins=(/,/^)/c\\$NEW_PLUGINS" ~/.zshrc
else
  echo "$NEW_PLUGINS" >> ~/.zshrc
fi

# Add the source line after plugins if not present
if ! grep -q "^source \$ZSH/oh-my-zsh.sh" ~/.zshrc; then
  sed -i "/^plugins=(/,/^)/a $SOURCE_LINE" ~/.zshrc
fi

# Update the theme line
if grep -q "^ZSH_THEME=" ~/.zshrc; then
  sed -i "s|^ZSH_THEME=.*|$NEW_THEME|" ~/.zshrc
else
  echo "$NEW_THEME" >> ~/.zshrc
fi

# Source the updated .zshrc
echo -e "${GREEN}Applying changes...${RESET}"
zsh -c "source ~/.zshrc"

# Clear the screen
clear
echo -e "${GREEN}Setup complete! Restart your terminal or type 'zsh' to use your new configuration.${RESET}"
