echo "Update Waybar for new Omadora menu"

if ! grep -q "" ~/.config/waybar/config.jsonc; then
  omarchy-refresh-waybar
fi
