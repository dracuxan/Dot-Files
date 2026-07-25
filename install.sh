#!/bin/bash

set -e # Exit on error

echo "-----------------------------------------"
echo "       DRACUXAN'S DOTFILES FOR DEBIAN    "
echo "-----------------------------------------"

echo "[+] Checking stow..."
if command -v stow >/dev/null 2>&1; then
    echo "[+] exists"
else
    echo "[-] stow does not exist! Please install manually"
    exit 1
fi

echo "[+] Stowing dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Preparing ~/.config layout..."
for dir in fastfetch nvim alacritty i3 i3status picom rofi dunst eww sioyek; do
    mkdir -p "$HOME/.config/$dir"
done

echo "[+] Stowing configs into ~/.config/..."

for dir in fastfetch nvim alacritty i3 i3status picom rofi dunst eww sioyek; do
    stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/$dir" "$dir"
done

stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config" starship

echo "[+] Stowing legacy dotfiles into ~/..."
for dir in zsh tmux iex; do
    stow --adopt -d "$DOTFILES_DIR" -t "$HOME" "$dir"
done

echo "[+] Building caps_watch..."
gcc -O2 -o "$DOTFILES_DIR/scripts/caps_watch" "$DOTFILES_DIR/scripts/caps_watch.c" -lX11

echo "[+] Stowing scripts into ~/.local/bin/..."
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.local/bin" scripts

echo "[+] Checking wallpaper config..."

if [[ ! -f "$HOME/.config/wallpaper.conf" ]]; then
    mkdir -p "$HOME/.config"
    echo "# Wallpaper Configuration" >"$HOME/.config/wallpaper.conf"
    echo "WALLPAPER_PATH=~/Wallpapers/anime_skull.png" >>"$HOME/.config/wallpaper.conf"
    echo "Created default wallpaper configuration"
fi

echo "-----------------------------------------"
echo "       SETUP COMPLETE. REBOOT NOW       "
echo "-----------------------------------------"
