#!/bin/bash
# Configure system-wide Inter font

FONTCONFIG_DIR="$HOME/.config/fontconfig"
FONTCONFIG_FILE="$FONTCONFIG_DIR/fonts.conf"

log_info "Setting up Inter font configuration..."

# Create fontconfig directory if it doesn't exist
mkdir -p "$FONTCONFIG_DIR"

# Create fontconfig file
cat > "$FONTCONFIG_FILE" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Default font for sans-serif -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Inter</family>
    </prefer>
  </alias>
  
  <!-- Default font for serif -->
  <alias>
    <family>serif</family>
    <prefer>
      <family>Inter</family>
    </prefer>
  </alias>
  
  <!-- Default font for monospace -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Inter</family>
    </prefer>
  </alias>
</fontconfig>
EOF

# Update font cache
fc-cache -fv

# Set GTK system fonts via gsettings
gsettings set org.gnome.desktop.interface font-name 'Inter 11' 2>/dev/null || true
gsettings set org.gnome.desktop.interface document-font-name 'Inter 11' 2>/dev/null || true
gsettings set org.gnome.desktop.interface monospace-font-name 'Inter 10' 2>/dev/null || true
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Inter Bold 11' 2>/dev/null || true

log_info "Inter font configuration complete"
