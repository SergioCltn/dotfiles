# Keep sudo credentials fresh for the whole install without touching sudoers.
#
# Steps run with output redirected to the install log, so a sudo password prompt
# halfway through would be hidden. Ask once up front, then refresh the cached
# credentials in the background until the installer exits.

start_sudo_keepalive() {
  sudo -v || exit 1

  # Stops on its own if the installer process ($$) goes away
  (
    while kill -0 "$$" 2>/dev/null; do
      sudo -n -v 2>/dev/null
      sleep 50
    done
  ) &
  SUDO_KEEPALIVE_PID=$!
}

stop_sudo_keepalive() {
  if [ -n "${SUDO_KEEPALIVE_PID:-}" ]; then
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    unset SUDO_KEEPALIVE_PID
  fi
}
