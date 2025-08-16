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

echo -e "\nCloning Titus-Omarchy from: https://github.com/${TITUS_REPO}.git"
rm -rf ~/.local/share/omarchy-titus/
git clone "https://github.com/${TITUS_REPO}.git" ~/.local/share/omarchy-titus >/dev/null

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
#show_logo beams 240
#show_subtext "Let's install! [1/5]"
source $OMARCHY_INSTALL/config/identification.sh
source $OMARCHY_INSTALL/config/config.sh
source $OMARCHY_INSTALL/config/detect-keyboard-layout.sh
#source $OMARCHY_INSTALL/config/fix-fkeys.sh # only for apple 
source $OMARCHY_INSTALL/config/network.sh
source $OMARCHY_INSTALL/config/power.sh
source $OMARCHY_INSTALL/config/timezones.sh
#source $OMARCHY_INSTALL/config/login.sh
source $OMARCHY_INSTALL/config/nvidia.sh

# Development
#show_logo decrypt 920
#show_subtext "Installing terminal tools [2/5]"
source $OMARCHY_INSTALL/development/terminal.sh
source $OMARCHY_INSTALL/development/development.sh
#source $OMARCHY_INSTALL/development/nvim.sh
source $OMARCHY_INSTALL/development/ruby.sh
source $OMARCHY_INSTALL/development/docker.sh
source $OMARCHY_INSTALL/development/firewall.sh

# Desktop
#show_logo slice 60
#show_subtext "Installing desktop tools [3/5]"
source $OMARCHY_INSTALL/desktop/desktop.sh
source $OMARCHY_INSTALL/desktop/hyprlandia.sh
source $OMARCHY_INSTALL/desktop/theme.sh
source $OMARCHY_INSTALL/desktop/bluetooth.sh
source $OMARCHY_INSTALL/desktop/asdcontrol.sh
source $OMARCHY_INSTALL/desktop/fonts.sh
source $OMARCHY_INSTALL/desktop/printer.sh

# Apps
#show_logo expand
#show_subtext "Installing default applications [4/5]"
#source $OMARCHY_INSTALL/apps/webapps.sh
#source $OMARCHY_INSTALL/apps/xtras.sh
source $OMARCHY_INSTALL/apps/mimetypes.sh

# Updates
#show_logo highlight
#show_subtext "Updating system packages [5/5]"
sudo mkinitcpio -P
sudo updatedb
sudo pacman -Syu --noconfirm

# Reboot
echo "Installation complete! Reboot when ready."