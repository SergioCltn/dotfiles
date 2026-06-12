#!/usr/bin/env bash
# =============================================================================
# Send selected text (or current line) to the Neovim instance in the current tmux pane
# Usage: bind-key in tmux → run-shell "tmux-neovim-remote.sh"
# =============================================================================

set -euo pipefail

# ─── Config ────────────────────────────────────────────────────────────────
LOGFILE="${HOME}/.tmux/nvim-remote.log"
mkdir -p "$(dirname "$LOGFILE")"

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

open_url() {
    local url="$1"

    if command -v xdg-open >/dev/null 2>&1; then
        nohup xdg-open "$url" >/dev/null 2>&1 &
    elif command -v open >/dev/null 2>&1; then
        nohup open "$url" >/dev/null 2>&1 &
    else
        die "No URL opener found for: $url"
    fi

    log info "Opened URL: $url"
    tmux display-message "Opened URL: $url"
}

nvim_socket_path() {
    local dir="$1"
    local root digest

    if root="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)"; then
        :
    else
        root="$(cd "$dir" && pwd -P)"
    fi

    if command -v sha1sum >/dev/null 2>&1; then
        digest="$(printf '%s' "$root" | sha1sum | cut -d' ' -f1)"
    else
        digest="$(printf '%s' "$root" | shasum | cut -d' ' -f1)"
    fi

    printf '%s/nvim-%s.sock\n' "${XDG_RUNTIME_DIR:-/tmp}" "$digest"
}

# ─── Main logic ────────────────────────────────────────────────────────────
CURRENT_PANE_PATH=$(tmux display-message -p '#{pane_current_path}')
log debug "Current pane path: $CURRENT_PANE_PATH"

# ─── Get content from tmux buffer and open URL or file ─────────────────────
if ! buffer_content=$(tmux show-buffer 2>/dev/null); then
    die "tmux show-buffer failed (buffer probably empty)"
fi

if [[ -z "$buffer_content" ]]; then
    die "Clipboard/buffer is empty"
fi

log debug "Got buffer content: '$buffer_content'"

if url=$(printf '%s\n' "$buffer_content" | grep -Eom1 'https?://[^[:space:]<>"'"'"']+'); then
    while [[ -n "$url" ]]; do
        case "${url: -1}" in
            ')' | ',' | '.' | ';') url="${url%?}" ;;
            *) break ;;
        esac
    done
    open_url "$url"
    exit 0
fi

# Use grep with a regex to extract potential file paths from the buffer.
# A path is considered a sequence of alphanumeric chars, and ./_~-
path_candidates=$(echo "$buffer_content" | grep -oE "[a-zA-Z0-9./_~-]+")

path=""
path_for_open=""
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
        path_for_open="$path_for_check_no_lines"
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

NVIM_SOCKET="$(nvim_socket_path "$CURRENT_PANE_PATH")"

if [[ ! -S "$NVIM_SOCKET" ]]; then
    OLD_SOCKET="${CURRENT_PANE_PATH%/}/nvim.sock"
    OLD_PARENT_SOCKET="${CURRENT_PANE_PATH%/*}/nvim.sock"

    if [[ -S "$OLD_SOCKET" ]]; then
        NVIM_SOCKET="$OLD_SOCKET"
        log info "Using legacy cwd socket: $NVIM_SOCKET"
    elif [[ -S "$OLD_PARENT_SOCKET" ]]; then
        NVIM_SOCKET="$OLD_PARENT_SOCKET"
        log info "Using legacy parent socket: $NVIM_SOCKET"
    else
        die "No Neovim server socket found at $NVIM_SOCKET"
    fi
fi

log debug "Using NVIM_SOCKET: $NVIM_SOCKET"

# ─── Try to send to nvim ───────────────────────────────────────────────────
if nvim --server "$NVIM_SOCKET" --remote "$path_for_open" 2>/dev/null; then
    log info "Successfully sent to nvim: ${path:0:60}${path:60:+...}."
else
    rc=$?
    log ERROR "nvim --remote failed (exit code $rc)"
    log debug "Command was: nvim --server '$NVIM_SOCKET' --remote '$path_for_open'"
    exit $rc
fi

exit 0
