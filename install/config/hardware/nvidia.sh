# Install Wayland EGL support only on machines with an NVIDIA GPU
if lspci | grep -iE 'vga|3d|display' | grep -qi 'nvidia'; then
  sudo pacman -S --needed --noconfirm egl-wayland
fi
