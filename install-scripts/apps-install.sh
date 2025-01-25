#!/bin/bash

# List of available apps from Flathub with descriptions
apps=(
"Warehouse - io.github.flattool.Warehouse - A tool to manage and organize flatpak apps and their metadata."
"Telegram - org.telegram.desktop - A fast, secure, and cloud-based messaging app."
"Discord - com.discordapp.Discord - A voice, video, and text chat platform for communities."
"Amberol - io.bassi.Amberol - A simple music player for Linux that supports FLAC and MP3."
"Chrome - com.google.Chrome - The web browser developed by Google, with a focus on speed and simplicity."
"Microsoft Edge - com.microsoft.Edge - A web browser developed by Microsoft, with Chromium as its engine."
"RustDesk - com.rustdesk.RustDesk - A remote desktop software that works like TeamViewer but is open-source."
"Termius - com.termius.Termius - A terminal app for managing SSH connections and working with remote servers."
"VLC player - org.videolan.VLC - A versatile media player capable of playing most audio and video formats."
"Wireshark - org.wireshark.Wireshark - A network protocol analyzer used for network troubleshooting."
"GIMP - org.gimp.GIMP - A free and open-source raster graphics editor used for tasks such as photo retouching and image composition."
"OBS Studio - com.obsproject.Studio - A powerful open-source software for video recording and live streaming."
"Nekoray - nekoray - Qt based cross-platform GUI proxy configuration manager"
"v2rayN - v2rayn - A GUI client for Windows, Linux and macOS, support Xray core and sing-box-core and others"
)

install_nekoray() {
  # Download nekoray version 3.26
  wget https://github.com/MatsuriDayo/nekoray/releases/download/3.26/nekoray-3.26-2023-12-09-linux64.zip -O nekoray.zip

  # Extract the downloaded file
  unzip nekoray.zip

  # Move folder to the appropriate directory
  sudo mv nekoray /opt/

  # Cleanup downloaded tarball
  rm -rf nekoray.zip

  #  create a desktop shortcut
  cat <<EOL >/usr/share/applications/nekoray.desktop
[Desktop Entry]
Encoding=UTF-8
Name=NekoRay
Exec=/opt/nekoray/nekoray
Icon=/opt/nekoray/nekoray.png
Type=Application
Categories=Network;
Terminal=false
EOL

  chmod +x /usr/share/applications/nekoray.desktop
}

install_v2rayn() {
  # Download v2rayN latest release
  wget https://github.com/2dust/v2rayN/releases/latest/download/v2rayN-linux-64.zip -O v2rayN.zip

  # Extract the downloaded file
  unzip v2rayN.zip

  # Move folder to the appropriate directory
  sudo mv v2rayN-linux-64 v2rayN
  sudo mv v2rayN /opt/

  # Cleanup downloaded tarball
  rm -rf v2rayN.zip

  #  create a desktop shortcut
  cat <<EOL >/usr/share/applications/v2rayn.desktop
[Desktop Entry]
Encoding=UTF-8
Name=v2rayN
Exec=/opt/v2rayN/v2rayN
Icon=/opt/v2rayN/v2rayN.png
Type=Application
Categories=Network;
Terminal=false
EOL

  chmod +x /usr/share/applications/v2rayn.desktop
}

# Display the app list to the user with descriptions
echo "Available apps to install from Flathub:"
for i in "${!apps[@]}"; do
  app_info="${apps[$i]}"
  app_name="${app_info%% -*}"
  app_desc="${app_info#* - }"
  app_desc="${app_desc#*- }" # Remove the app package name

  echo "$((i+1)). $app_name - $app_desc"
done

# Prompt user for input
echo -n "Enter the numbers of the apps you want to install (e.g., 1 2 5 10): "
read -a user_input

# Loop through the user input and install the selected apps
for num in "${user_input[@]}"; do
  app_index=$((num-1)) # Adjust for 0-based index
  app_name="${apps[$app_index]#* - }"
  app_name="${app_name%% *}"
  echo "Installing $app_name from Flathub..."
  if [ "$app_name" == 'nekoray' ]; then
    install_nekoray
  elif [ "$app_name" == 'v2rayn' ]; then
    install_v2rayn
  else
    flatpak install -y flathub "$app_name" # Installing from Flathub
  fi
done

clear
echo "Installation complete!"