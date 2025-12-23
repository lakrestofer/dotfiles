{
  description = "Configuration file for my nixos systems";
  outputs = inputs: import ./outputs.nix inputs;
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";
    kmonad.url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
    home-manager.url = "github:nix-community/home-manager";
    helix.url = "github:mattwparas/helix";
    spbased.url = "github:lakrestofer/spbased";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
}
