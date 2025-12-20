# Hyprland Key Remapping Guide  
**Left Alt → Backspace** • **Backspace → Escape**  

```bash
# 1. Install keyd (one time)
sudo pacman -S keyd
# Fedora:   sudo dnf install keyd
# Debian/Ubuntu: sudo apt install keyd
# NixOS:    services.keyd.enable = true;

# 2. Enable and start the service (one time)
sudo systemctl enable --now keyd

# 3. Create the config file
sudo mkdir -p /etc/keyd
sudo nvim /etc/keyd/default.conf

## Paste this exact content
##start
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

##end 

# 4. Apply
sudo keyd reload

```

