#!/bin/bash

# Install SDDM on Arch Linux
sudo pacman -S sddm

sudo mkdir -p /etc/sddm.conf.d

if [ ! -f /etc/sddm.conf.d/autologin.conf ]; then
  cat <<EOF | sudo tee /etc/sddm.conf.d/autologin.conf
[Autologin]
User=$USER

[Theme]
Current=breeze
EOF
fi

# Don't use chrootable here as --now will cause issues for manual installs
sudo systemctl enable sddm.service
# Enable SDDM service
sudo systemctl enable sddm

# Start SDDM service
sudo systemctl start sddm
