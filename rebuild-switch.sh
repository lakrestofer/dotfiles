#/usr/bin/env bash
# A rebuild script that commits on a successful build
# adapted from <https://gist.githubusercontent.com/0atman/1a5133b842f929ba4c1e195ee67599d5/raw/4e2f3ad34edb07843db9d6abb7c340bba611c07e/nixos-rebuild.sh>

# Would be nice if this script also had some search and edit feature
# making the script the first point of contact whenever I want
# to alter my configuration
# feature list
# [ ] open rofi/fzf and search for files that we can change
# [ ] on change of file, run test to check for valid file
# [ ] on valid config file, rebuild and switch

set -e

pushd ~/dotfiles/

if git diff --quiet ; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# show all changed lines
git diff -U0

# rebuild and switch
echo "rebuilding... log written to nixos-switch.log"
sudo nixos-rebuild switch --flake ./ &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes within the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
echo "NixOS Rebuilt OK!"
#notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
