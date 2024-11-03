#/usr/bin/env bash

sudo nixos-rebuild switch --flake ./ &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

