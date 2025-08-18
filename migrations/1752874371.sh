echo "Add Catppuccin Latte light theme"
if [[ ! -L "~/.config/omarchy/themes/catppuccin-latte" ]]; then
  ln -snf ~/.local/share/omadora/themes/catppuccin-latte ~/.config/omarchy/themes/
fi
