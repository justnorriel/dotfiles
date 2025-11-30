# 1. Go to your dotfiles folder
cd ~/dotfiles

# 2. Remove the old folders (we’ll replace them with fresh ones)
rm -rf ~/dotfiles/hypr ~/dotfiles/waybar

# 3. Copy your CURRENT live configs into the repo
cp -r ~/.config/hypr ~/dotfiles/
cp -r ~/.config/waybar ~/dotfiles/

# 4. (Optional but recommended) Also grab any other common ones you might want
cp -r ~/.config/wofi   ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/dunst  ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/kitty  ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/mako   ~/dotfiles/ 2>/dev/null || true
cp -r ~/.config/rofi   ~/dotfiles/ 2>/dev/null || true

# 5. Check what you just copied
ls -la ~/dotfiles

# 6. Add, commit and push the fresh versions
git add .
git commit -m "update: fresh hypr & waybar configs $(date +%Y-%m-%d)"
git push
