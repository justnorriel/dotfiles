#!/usr/bin/env bash

# Hyprland Key Remapping Setup Script
# Left Alt → Backspace | Backspace → Escape
# Requires root privileges for installation and config

set -e  # Exit on any error

echo "=== Hyprland Key Remapping: Left Alt -> Backspace, Backspace -> Escape ==="

# Detect package manager (supports common distros)
if command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="pacman -S --needed --noconfirm keyd"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="dnf install -y keyd"
elif command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="apt update && apt install -y keyd"
else
    echo "Error: Unsupported distro. Supported: Arch (pacman), Fedora (dnf), Debian/Ubuntu (apt)."
    echo "For NixOS, enable via Nix config instead (services.keyd.enable = true;)."
    exit 1
fi

# Install keyd if not already installed
if ! command -v keyd &> /dev/null; then
    echo "Installing keyd using $PKG_MANAGER..."
    sudo $INSTALL_CMD
else
    echo "keyd is already installed."
fi

# Enable and start the service
echo "Enabling and starting keyd service..."
sudo systemctl enable --now keyd

# Create config directory if needed
sudo mkdir -p /etc/keyd

# Write the configuration file
CONFIG_FILE="/etc/keyd/default.conf"
echo "Writing configuration to $CONFIG_FILE..."

sudo tee "$CONFIG_FILE" > /dev/null << 'EOF'
[ids]
*

[main]

# Left Alt key → Backspace (repeats perfectly when held)
leftalt = backspace

# Physical Backspace key → Escape (ideal for Vim, dialogs, etc.)
backspace = escape

# Right Alt stays normal Alt (you keep all shortcuts)
# (optional) uncomment next line if you want Right Alt to be normal Left Alt too:
# rightalt = leftalt
EOF

# Reload keyd to apply changes
echo "Reloading keyd configuration..."
sudo keyd reload

echo ""
echo "=== Setup complete! ==="
echo "Left Alt now acts as Backspace."
echo "Physical Backspace now acts as Escape."
echo "Changes take effect immediately (system-wide, including Hyprland)."
echo ""
echo "If you mess up the config in the future and lock yourself out:"
echo "Press Backspace + Escape + Enter simultaneously to force-terminate keyd."
echo ""
echo "To edit manually later: sudo nvim /etc/keyd/default.conf && sudo keyd reload"
