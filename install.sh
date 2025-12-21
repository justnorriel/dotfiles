#!/usr/bin/env bash
set -e

echo "🚀 Installing wanshii's Hyprland dotfiles with GNU stow"

# Backup existing configs (safety first)
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

echo "✅ Dotfiles installed! Reload Hyprland with hyprctl reload"
