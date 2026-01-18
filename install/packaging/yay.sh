if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm base-devel git
    tmp_dir=$(mktemp -d)
    cd "$tmp_dir"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
    rm -rf "$tmp_dir"
fi

mapfile -t packages < <(grep -v '^#' "$DOTFILES_INSTALL/hyprland-yay.packages" | grep -v '^$')
yay -S --noconfirm --needed "${packages[@]}"
