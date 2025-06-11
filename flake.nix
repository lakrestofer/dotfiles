{
  description = "Configuration file for my nixos systems";
  outputs = inputs: import ./outputs.nix inputs;
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";
    kmonad.url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
    home-manager.url = "github:nix-community/home-manager";
    helix.url = "github:helix-editor/helix";
    spbased.url = "github:lakrestofer/spbased";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    walker.url = "github:abenz1267/walker";
  };
}
