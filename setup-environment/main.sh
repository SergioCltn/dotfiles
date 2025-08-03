#!/bin/bash

# main.sh
# Entry point for the Linux development environment setup

# Exit on error
set -e

# Source all necessary scripts
source ./functions.sh
source ./install_packages.sh
source ./setup_dotfiles.sh

print_message "Development environment setup complete! Please restart your terminal or source your shell configuration."
