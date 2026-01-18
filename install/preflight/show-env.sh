# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(DOTFILES_CHROOT_INSTALL|DOTFILES_ONLINE_INSTALL|DOTFILES_USER_NAME|DOTFILES_USER_EMAIL|USER|HOME|DOTFILES_REPO|DOTFILES_REF|DOTFILES_PATH)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done
