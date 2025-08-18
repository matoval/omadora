echo "Add new matte black theme"

if [[ ! -L "~/.config/omarchy/themes/matte-black" ]]; then
  ln -snf ~/.local/share/omadora/themes/matte-black ~/.config/omarchy/themes/
fi
