DOTFILES_PATH="${DOTFILES_PATH:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
SDDM_THEME_DIR=/usr/share/sddm/themes/silent

sudo mkdir -p /etc/sddm.conf.d

# Show the login screen instead of logging in automatically
sudo rm -f /etc/sddm.conf.d/autologin.conf
sudo cp "$DOTFILES_PATH/default/sddm/theme.conf" /etc/sddm.conf.d/theme.conf

# Style the Silent theme to match hyprlock. SDDM reads <ConfigFile>.user on top of the
# theme config, so these survive theme package updates. The greeter can't read $HOME,
# so the wallpaper is copied into the theme.
if [ -d "$SDDM_THEME_DIR" ]; then
  sudo cp "$DOTFILES_PATH/default/sddm/silent.conf.user" "$SDDM_THEME_DIR/configs/default.conf.user"
  sudo cp "$DOTFILES_PATH/hyprland/.config/hypr/wallpaper.jpg" "$SDDM_THEME_DIR/backgrounds/dotfiles-wallpaper.jpg"
fi

# Don't use chrootable here as --now will cause issues for manual installs
sudo systemctl enable sddm.service
