#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install git first
echo "Installing git..."
sudo pacman -S --noconfirm --needed git

# Use custom repo if specified, otherwise default to basecamp/omarchy
OMARCHY_REPO="${OMARCHY_REPO:-basecamp/omarchy}"
TITUS_REPO="${TITUS_REPO:-christitustech/omarchy-titus}"

echo -e "\nCloning Omarchy from: https://github.com/${OMARCHY_REPO}.git"
rm -rf ~/.local/share/omarchy/
git clone "https://github.com/${OMARCHY_REPO}.git" ~/.local/share/omarchy >/dev/null

# Use custom branch if instructed
if [[ -n "$OMARCHY_REF" ]]; then
  echo -e "\nUsing branch: $OMARCHY_REF"
  cd ~/.local/share/omarchy
  git fetch origin "${OMARCHY_REF}" && git checkout "${OMARCHY_REF}"
  cd -
fi

echo -e "\nInstallation starting..."

# Set up environment
export PATH="$HOME/.local/share/omarchy/bin:$PATH"
OMARCHY_INSTALL=~/.local/share/omarchy/install

# Install prerequisites
source $OMARCHY_INSTALL/preflight/guard.sh
source $OMARCHY_INSTALL/preflight/aur.sh
source $OMARCHY_INSTALL/preflight/presentation.sh
source $OMARCHY_INSTALL/preflight/migrations.sh

# Configuration
source $OMARCHY_INSTALL/config/identification.sh
source $OMARCHY_INSTALL/config/config.sh
source $OMARCHY_INSTALL/config/detect-keyboard-layout.sh
source $OMARCHY_INSTALL/config/network.sh
source $OMARCHY_INSTALL/config/power.sh
source $OMARCHY_INSTALL/config/timezones.sh
source $OMARCHY_INSTALL/config/nvidia.sh

# Development
source $OMARCHY_INSTALL/development/terminal.sh
source $OMARCHY_INSTALL/development/development.sh
source $OMARCHY_INSTALL/development/ruby.sh
source $OMARCHY_INSTALL/development/docker.sh
source $OMARCHY_INSTALL/development/firewall.sh

# Desktop
source $OMARCHY_INSTALL/desktop/desktop.sh
source $OMARCHY_INSTALL/desktop/hyprlandia.sh
source $OMARCHY_INSTALL/desktop/theme.sh
source $OMARCHY_INSTALL/desktop/bluetooth.sh
source $OMARCHY_INSTALL/desktop/fonts.sh
source $OMARCHY_INSTALL/desktop/printer.sh

# Removes Chromium and install Firefox
if pacman -Qi chromium &>/dev/null; then
    sudo pacman -Rns --noconfirm chromium
fi
yay -S --noconfirm --needed firefox

# Install hyprpolkitagent
if pacman -Qi hyprpolkitagent &>/dev/null; then
    exit 1
else
    yay -S hyprpolkitagent
fi

# Apps
source $OMARCHY_INSTALL/apps/mimetypes.sh

# Installing Rofi and my config
yay -S --noconfirm --needed rofi-wayland
mkdir -p ~/.config/rofi
wget -O ~/.config/rofi/config.rasi https://raw.githubusercontent.com/avaera8775/dwm-setup/refs/heads/main/suckless/rofi/config.rasi
wget -O ~/.config/rofi/power.rasi https://raw.githubusercontent.com/avaera8775/dwm-setup/refs/heads/main/suckless/rofi/power.rasi

# Updates
sudo mkinitcpio -P
sudo updatedb
sudo pacman -Syu --noconfirm

# Link overwrite config
ln -s $(pwd)/hypr $HOME/.config/

# Reboot
echo "Installation complete! Reboot when ready."