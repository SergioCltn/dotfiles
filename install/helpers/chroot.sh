# Starting the installer with DOTFILES_CHROOT_INSTALL=1 will put it into chroot mode
#
# Chroot mode is when the installer runs in a chroot environment (
# activated by setting DOTFILES_CHROOT_INSTALL=1), where systemctl
# enable skips the --now flag to avoid starting services immediately,
# as the system isn't fully booted.
# TODO: it's not set in anywhere

chrootable_systemctl_enable() {
  if [ -n "${DOTFILES_CHROOT_INSTALL:-}" ]; then
    sudo systemctl enable $1
  else
    sudo systemctl enable --now $1
  fi
}

# Export the function so it's available in subshells
export -f chrootable_systemctl_enable
