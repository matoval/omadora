echo "Improve tooltip for Omadora menu icon"

if grep -q "SUPER + ALT + SPACE" ~/.config/waybar/config.jsonc; then
  sed -i 's/SUPER + ALT + SPACE/Omadora Menu\\n\\nSuper + Alt + Space/' ~/.config/waybar/config.jsonc
fi
