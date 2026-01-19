stop_install_log

clear

# Display installation time if available
if [[ -f $DOTFILES_INSTALL_LOG_FILE ]] && grep -q "Total:" "$DOTFILES_INSTALL_LOG_FILE" 2>/dev/null; then
  echo
  TOTAL_TIME=$(tail -n 20 "$DOTFILES_INSTALL_LOG_FILE" | grep "^Total:" | sed 's/^Total:[[:space:]]*//')
  if [ -n "$TOTAL_TIME" ]; then
    echo "Installed in $TOTAL_TIME"
  fi
else
  echo "Finished installing"
fi


