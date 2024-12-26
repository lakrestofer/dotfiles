{
  description = "Configuration file for my nixos systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # hyprland stuff
    hyprland.url = "github:hyprwm/Hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprpaper.url = "github:hyprwm/hyprlock";
    # kmonad
    kmonad.url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
    kmonad.inputs.nixpkgs.follows = "nixpkgs";
    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # some other applications
    helix.url = "github:helix-editor/helix";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # local flakes
    agsbar.url = "file:///home/fincei/dotfiles/home/ags";
  };

  outputs = { self, kmonad, home-manager, nixpkgs, astal, ags, nixos-hardware, ... } @ inputs:
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
        nixos-hardware.nixosModules.lenovo-thinkpad-x220
        home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fincei = import ./home.nix;
            home-manager.backupFileExtension = "backup";
        }
      ];
    };

  };
}
