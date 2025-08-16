#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

export PATH="$HOME/.local/share/omadora/bin:$PATH"
OMADORA_INSTALL=~/.local/share/omadora/install

# Give people a chance to retry running the installation
catch_errors() {
  echo -e "\n\e[31mOmadora installation failed!\e[0m"
  echo "You can retry by running: bash ~/.local/share/omadora/install.sh"
  echo "Get help from the community: https://github.com/matoval/omadora/issues"
}

trap catch_errors ERR

show_logo() {
  clear
  # tte -i ~/.local/share/omadora/logo.txt --frame-rate ${2:-120} ${1:-expand}
  cat <~/.local/share/omadora/logo.txt
  echo
}

show_subtext() {
  echo "$1" # | tte --frame-rate ${3:-640} ${2:-wipe}
  echo
}

# Install prerequisites
source $OMADORA_INSTALL/preflight/guard.sh
source $OMADORA_INSTALL/preflight/fedora-repos.sh
source $OMADORA_INSTALL/preflight/presentation.sh
source $OMADORA_INSTALL/preflight/migrations.sh

# Configuration
show_logo beams 240
show_subtext "Let's install Omadora! [1/5]"
source $OMADORA_INSTALL/config/identification.sh
source $OMADORA_INSTALL/config/config.sh
source $OMADORA_INSTALL/config/detect-keyboard-layout.sh
source $OMADORA_INSTALL/config/fix-fkeys.sh
source $OMADORA_INSTALL/config/network.sh
source $OMADORA_INSTALL/config/power.sh
source $OMADORA_INSTALL/config/timezones.sh
source $OMADORA_INSTALL/config/login.sh
source $OMADORA_INSTALL/config/nvidia.sh

# Development
show_logo decrypt 920
show_subtext "Installing terminal tools [2/5]"
source $OMADORA_INSTALL/development/terminal.sh
source $OMADORA_INSTALL/development/development.sh
source $OMADORA_INSTALL/development/nvim.sh
source $OMADORA_INSTALL/development/ruby.sh
source $OMADORA_INSTALL/development/docker.sh
source $OMADORA_INSTALL/development/firewall.sh

# Desktop
show_logo slice 60
show_subtext "Installing desktop tools [3/5]"
source $OMADORA_INSTALL/desktop/desktop.sh
source $OMADORA_INSTALL/desktop/hyprlandia.sh
source $OMADORA_INSTALL/desktop/theme.sh
source $OMADORA_INSTALL/desktop/bluetooth.sh
source $OMADORA_INSTALL/desktop/asdcontrol.sh
source $OMADORA_INSTALL/desktop/fonts.sh
source $OMADORA_INSTALL/desktop/printer.sh

# Apps
show_logo expand
show_subtext "Installing default applications [4/5]"
source $OMADORA_INSTALL/apps/webapps.sh
source $OMADORA_INSTALL/apps/xtras.sh
source $OMADORA_INSTALL/apps/mimetypes.sh

# Updates
show_logo highlight
show_subtext "Updating system packages [5/5]"
sudo updatedb
# Exclude uwsm from updates (equivalent to Arch's --ignore uwsm)
sudo dnf upgrade -y --exclude=uwsm

# Reboot
show_logo laseretch 920
show_subtext "You're done! So we'll be rebooting now..."
sleep 2
reboot
