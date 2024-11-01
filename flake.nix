{
  description = "Configuration file for my nixos systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, kmonad, nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.machina = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix # base configuration
        kmonad.nixosModules.default
      ];
    };

  };
}
