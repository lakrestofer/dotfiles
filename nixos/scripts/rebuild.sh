#!/usr/bin/env bash

# A rebuild script that commits on a successful build
set -e

pushd '~/dotfiles'

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet 'nixos/*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
# alejandra . &>/dev/null \ || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
#sudo nixos-rebuild switch --flake &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes within the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
