#!/bin/bash

# Validate shell scripts, Lua and JSON configs in this repo. Used by `make check`.

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

failed=0

# run_check <label> <command...>: run a command and report pass/fail
run_check() {
  local label=$1
  shift
  if "$@"; then
    echo "✓ $label"
  else
    echo "✗ $label"
    failed=1
  fi
}

# Shell scripts: anything with a sh/bash shebang, plus *.sh files
mapfile -t scripts < <(
  {
    grep -rlE '^#!.*\b(ba)?sh\b' --exclude-dir=.git --exclude-dir=node_modules .
    find . -path ./.git -prune -o -name '*.sh' -type f -print
  } | sed 's|^\./||' | sort -u
)

# shellcheck disable=SC2329 # called via run_check
bash_syntax() {
  local script ok=0
  for script in "$@"; do
    bash -n "$script" || ok=1
  done
  return "$ok"
}
run_check "bash -n (${#scripts[@]} scripts)" bash_syntax "${scripts[@]}"

if command -v shellcheck >/dev/null 2>&1; then
  # SC1091: sourced files are resolved at runtime from $DOTFILES_INSTALL
  run_check "shellcheck" shellcheck -S info -e SC1091 -s bash "${scripts[@]}"
else
  echo "- shellcheck not installed, skipping"
fi

# Lua
run_check "hyprland.lua syntax" luac -p hyprland/.config/hypr/hyprland.lua

stylua_bin=$(command -v stylua || echo "$HOME/.local/share/nvim/mason/bin/stylua")
if [[ -x $stylua_bin ]]; then
  run_check "stylua (nvim)" "$stylua_bin" --check config/nvim/.config/nvim
else
  echo "- stylua not installed, skipping"
fi

# JSON
for json in hyprland/.config/waybar/config config/opencode/.config/opencode/opencode.jsonc; do
  run_check "$json is valid JSON" python3 -m json.tool "$json" /dev/null
done

exit "$failed"
