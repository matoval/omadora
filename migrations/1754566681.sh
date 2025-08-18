echo "Make new Osaka Jade theme available as new default"

if [[ ! -L ~/.config/omarchy/themes/osaka-jade ]]; then
  rm -rf ~/.config/omarchy/themes/osaka-jade
  git -C ~/.local/share/omadora checkout -f themes/osaka-jade
  ln -nfs ~/.local/share/omadora/themes/osaka-jade ~/.config/omarchy/themes/osaka-jade
fi
