# Install the Broadcom wireless driver only on machines with a Broadcom network card
if lspci | grep -iE 'network|ethernet' | grep -qi 'broadcom'; then
  sudo pacman -S --needed --noconfirm broadcom-wl
fi
