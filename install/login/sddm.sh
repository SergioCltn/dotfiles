DOTFILES_PATH="${DOTFILES_PATH:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
SDDM_SOURCE_THEME=/usr/share/sddm/themes/silent
SDDM_THEME_DIR=/usr/share/sddm/themes/silent-minimal

sudo mkdir -p /etc/sddm.conf.d

# Show the login screen instead of logging in automatically
sudo rm -f /etc/sddm.conf.d/autologin.conf
sudo cp "$DOTFILES_PATH/default/sddm/theme.conf" /etc/sddm.conf.d/theme.conf

# Build silent-minimal from the Silent theme so package updates don't undo the tweaks.
# Rerun this script after updating sddm-silent-theme or changing the wallpaper.
if [ -d "$SDDM_SOURCE_THEME" ]; then
  # Earlier versions of this script customised the Silent theme in place
  sudo rm -f "$SDDM_SOURCE_THEME/configs/default.conf.user" "$SDDM_SOURCE_THEME/backgrounds/dotfiles-wallpaper.jpg"

  sudo rm -rf "$SDDM_THEME_DIR"
  sudo cp -r "$SDDM_SOURCE_THEME" "$SDDM_THEME_DIR"

  # Empty password placeholder; a space keeps the text padding so only the cursor shows
  sudo sed -i 's/placeholder: (textConstants \&\& textConstants.password) ? textConstants.password : "Password"/placeholder: " "/' \
    "$SDDM_THEME_DIR/components/LoginScreen.qml"

  # SDDM reads <ConfigFile>.user on top of the theme config. The greeter can't read
  # $HOME, so the wallpaper is copied into the theme.
  sudo cp "$DOTFILES_PATH/default/sddm/silent.conf.user" "$SDDM_THEME_DIR/configs/default.conf.user"
  sudo cp "$DOTFILES_PATH/hyprland/.config/hypr/wallpaper.jpg" "$SDDM_THEME_DIR/backgrounds/dotfiles-wallpaper.jpg"
fi

# Don't use chrootable here as --now will cause issues for manual installs
sudo systemctl enable sddm.service
