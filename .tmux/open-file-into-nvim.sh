#!/usr/bin/env bash
# =============================================================================
# Send selected text (or current line) to the Neovim instance in the current tmux pane
# Usage: bind-key in tmux → run-shell "tmux-neovim-remote.sh"
# =============================================================================

set -euo pipefail

# ─── Config ────────────────────────────────────────────────────────────────
LOGFILE="${HOME}/.tmux/nvim-remote.log"

# ─── Helper functions ──────────────────────────────────────────────────────
log() {
    local level="$1"; shift

    printf '[%(%Y-%m-%d %H:%M:%S)T] %-5s %s\n' -1 "$level" "$*" >> "$LOGFILE"
}

die() {
    log "ERROR" "$*"
    tmux display-message "nvim-remote ERROR: $*"
    exit 0
}

# ─── Main logic ────────────────────────────────────────────────────────────
CURRENT_PANE_PATH=$(tmux display-message -p '#{pane_current_path}')
log debug "Current pane path: $CURRENT_PANE_PATH"

NVIM_SOCKET="${CURRENT_PANE_PATH%/}/nvim.sock"

if [[ ! -S "$NVIM_SOCKET" ]]; then
    # Try one level up (common when inside a git worktree subdirectory)
    ALT_SOCKET="${CURRENT_PANE_PATH%/*}/nvim.sock"
    if [[ -S "$ALT_SOCKET" ]]; then
        NVIM_SOCKET="$ALT_SOCKET"
        log info "Found nvim socket one directory up: $NVIM_SOCKET"
    else
        die "No Neovim server socket found at $NVIM_SOCKET (or parent dir)"
    fi
fi

log debug "Using NVIM_SOCKET: $NVIM_SOCKET"

# ─── Get content from tmux buffer and find a valid path ───────────────────
if ! buffer_content=$(tmux show-buffer 2>/dev/null); then
    die "tmux show-buffer failed (buffer probably empty)"
fi

if [[ -z "$buffer_content" ]]; then
    die "Clipboard/buffer is empty"
fi

log debug "Got buffer content: '$buffer_content'"

# Use grep with a regex to extract potential file paths from the buffer.
# A path is considered a sequence of alphanumeric chars, and ./_~-
path_candidates=$(echo "$buffer_content" | grep -oE "[a-zA-Z0-9./_~-]+")

path=""
for candidate in $path_candidates; do
    # The candidate might have a `~` that needs to be expanded.
    if [[ "${candidate:0:1}" == "~" ]]; then
        expanded_candidate="$HOME${candidate:1}"
    else
        expanded_candidate="$candidate"
    fi

    # If the path is not absolute, it's relative to the current pane's path.
    path_for_check="$expanded_candidate"
    if [[ "$expanded_candidate" != /* ]]; then
        path_for_check="$CURRENT_PANE_PATH/$expanded_candidate"
    fi

    # A path can have line/column numbers (e.g., file:10:5), remove them for the check.
    path_for_check_no_lines="${path_for_check%%:*}"

    if [[ -e "$path_for_check_no_lines" ]]; then
        path="$candidate"
        log info "Found existing file path in buffer: '$path'"
        break
    fi
done

if [[ -z "$path" ]]; then
    die "No valid file path found in clipboard: '$buffer_content'"
fi

log debug "Using path: '${path}' (length: ${#path})"

if [[ ${#path} -gt 400 ]]; then
    log info "Selection is very long (${#path} chars) — sending anyway"
fi

# ─── Try to send to nvim ───────────────────────────────────────────────────
if nvim --server "$NVIM_SOCKET" --remote-send "<Cmd>edit $path<CR>" 2>/dev/null; then
    log info "Successfully sent to nvim: ${path:0:60}${path:60:+...}."
else
    local rc=$?
    log ERROR "nvim --remote failed (exit code $rc)"
    log debug "Command was: nvim --server '$NVIM_SOCKET' --remote '$path'"
    exit $rc
fi

exit 0
