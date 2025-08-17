#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine if we're running from repo or installed location
if [ -d "$SCRIPT_DIR/install" ]; then
  # Running from cloned repository
  OMADORA_INSTALL="$SCRIPT_DIR/install"
  export PATH="$SCRIPT_DIR/bin:$PATH"
else
  # Running from installed location
  OMADORA_INSTALL=~/.local/share/omadora/install
  export PATH="$HOME/.local/share/omadora/bin:$PATH"
fi

# Give people a chance to retry running the installation
catch_errors() {
  echo -e "\n\e[31mOmadora installation failed!\e[0m"
  echo "You can retry by running: bash ~/.local/share/omadora/install.sh"
  echo "Get help from the community: https://github.com/matoval/omadora/issues"
}

trap catch_errors ERR

show_logo() {
  clear
  # Determine logo path based on where we're running from
  if [ -f "./logo.txt" ]; then
    # Running from cloned repository
    LOGO_PATH="./logo.txt"
  else
    # Running from installed location
    LOGO_PATH="$HOME/.local/share/omadora/logo.txt"
  fi
  
  # tte -i $LOGO_PATH --frame-rate ${2:-120} ${1:-expand}
  cat <"$LOGO_PATH" 2>/dev/null || echo "Omadora"
  echo
}

show_subtext() {
  echo "$1" # | tte --frame-rate ${3:-640} ${2:-wipe}
  echo
}

# Install prerequisites
# Install gum first for interactive prompts
sudo dnf install -y gum

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
# Update locate database if available
if command -v updatedb &>/dev/null; then
  echo "Updating locate database..."
  sudo updatedb || echo "Failed to update locate database - continuing"
else
  echo "updatedb not found - skipping locate database update"
fi
# Exclude uwsm from updates (equivalent to Arch's --ignore uwsm)
echo "Upgrading system packages..."
sudo dnf upgrade -y --exclude=uwsm || echo "System upgrade encountered issues - continuing"

# Reboot
show_logo laseretch 920
show_subtext "You're done! So we'll be rebooting now..."
sleep 2
reboot
