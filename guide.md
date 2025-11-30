# Getting dotfiles into a folder to github
## 1. Go to your dotfiles folder
cd ~/dotfiles

## 2. Remove the old folders (we’ll replace them with fresh ones)
rm -rf ~/dotfiles/hypr ~/dotfiles/waybar

## 3. Copy your CURRENT live configs into the repo
cp -r ~/.config/hypr ~/dotfiles/
cp -r ~/.config/waybar ~/dotfiles/

## 4. (Optional but recommended) Also grab any other common ones you might want
cp -r ~/.config/wofi   ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/dunst  ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/kitty  ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/mako   ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/rofi   ~/dotfiles/ 2>/dev/null || true

## 5. Check what you just copied
ls -la ~/dotfiles

## 6. Add, commit and push the fresh versions
git add .
git commit -m "update: fresh hypr & waybar configs $(date +%Y-%m-%d)"
git push


# Creating stow-friendly dotfiles config
cd ~/dotfiles

## 1. Create the standard config/ folder
mkdir -p config

## 2. Move every config folder into config/ (hypr, waybar, and anything else you have)
## This grabs all folders except .git, .gitignore, etc.
find . -maxdepth 1 -type d ! -name '.' ! -name '.git' ! -name 'config' -exec mv {} config/ \;

## 3. Quick check that it worked
ls -la config/

## 4. Add the stow-friendly install script
cat > install.sh << 'EOF'
#!/usr/bin/env bash
set -e

echo "🚀 Installing wanshii's Hyprland dotfiles with GNU stow"

## Backup existing configs (safety first)
backup="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup"

for dir in config/*/; do
    dirname="$(basename "$dir")"
    if [[ -d "$HOME/.config/$dirname" && ! -L "$HOME/.config/$dirname" ]]; then
        echo "Backing up ~/.config/$dirname → $backup/"
        mv "$HOME/.config/$dirname" "$backup/"
    fi
done

# Use stow if available, otherwise fallback to rsync
if command -v stow >/dev/null 2>&1; then
    echo "Symlinking with stow..."
    stow -R --target="$HOME/.config" config
else
    echo "stow not found → falling back to rsync"
    rsync -av --delete config/ "$HOME/.config/"
fi

echo "✅ Dotfiles installed! Reload Hyprland or log out/in"
EOF

chmod +x install.sh

## 5. Commit the restructure
git add .
git commit -m "refactor: make repo GNU stow compatible + add install.sh"

## 6. Push the changes
git push
