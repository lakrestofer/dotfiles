# My configuration!

This repo contains my nixos configuration for various hosts. It is
written with my usecases in mind.

## Current state

It's quite good! There are some lesser issues though.

- some evaluation warning?
  - "You have set specialArgs.pkgs, which means that options like
    nixpkgs.config and nixpkgs.overlays will be ignored. If you wish
    to reuse an already created pkgs, which you know is configured
    correctly for this NixOS configuration, please import the
    `nixosModules.readOnlyPkgs` module from the nixpkgs flake or
    `(modulesPath + "/misc/nixpkgs/read-only.nix"), and set`{
    nixpkgs.pkgs = <your pkgs>; }`. This properly disables the ignored
    options to prevent future surprises."
- no lock screen
  - nuked it to prevent lock screen on desktop, still want it on
    laptop
- handling of wallpaper on walking up from suspend on desktop, does
  not handle the software defined rotation on two of my monitors well.
- no backup solution
  - the data that I want backed up currently lives in a syncthing
    folder
- cannot fully reproduce my system from my configuration.
  - data and keys
