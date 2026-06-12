#!/bin/bash

set -eEo pipefail

DOTFILES_INSTALL="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_INSTALL/first-run/dns-resolver.sh"
source "$DOTFILES_INSTALL/first-run/firewall.sh"
