#!/bin/bash

# Validate shell scripts, Lua and JSON configs in this repo. Used by `make check`.

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

failed=0

pass() { echo "✓ $1"; }
fail() { echo "✗ $1"; failed=1; }

# Shell scripts: anything with a sh/bash shebang, plus *.sh files
mapfile -t scripts < <(
  {
    grep -rlE '^#!.*\b(ba)?sh\b' --exclude-dir=.git --exclude-dir=node_modules .
    find . -path ./.git -prune -o -name '*.sh' -type f -print
  } | sed 's|^\./||' | sort -u
)

syntax_ok=1
for script in "${scripts[@]}"; do
  bash -n "$script" || syntax_ok=0
done
((syntax_ok)) && pass "bash -n (${#scripts[@]} scripts)" || fail "bash -n"

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -S warning -s bash "${scripts[@]}" && pass "shellcheck" || fail "shellcheck"
else
  echo "- shellcheck not installed, skipping"
fi

# Lua
luac -p hyprland/.config/hypr/hyprland.lua && pass "hyprland.lua syntax" || fail "hyprland.lua syntax"

stylua_bin=$(command -v stylua || echo "$HOME/.local/share/nvim/mason/bin/stylua")
if [[ -x $stylua_bin ]]; then
  "$stylua_bin" --check config/nvim/.config/nvim >/dev/null && pass "stylua (nvim)" || fail "stylua (nvim): run stylua config/nvim/.config/nvim"
else
  echo "- stylua not installed, skipping"
fi

# JSON
for json in hyprland/.config/waybar/config config/opencode/.config/opencode/opencode.jsonc; do
  python3 -m json.tool "$json" >/dev/null && pass "$json is valid JSON" || fail "$json is invalid JSON"
done

exit "$failed"
