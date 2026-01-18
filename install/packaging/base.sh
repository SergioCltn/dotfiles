# Install all base packages
mapfile -t packages < <(grep -v '^#' "$DOTFILES_INSTALL/hyprland-base.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"
