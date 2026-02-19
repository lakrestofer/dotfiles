{
  description = "Configuration file for my nixos systems";
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # import-tree.url = "github:vic/import-tree";

    niri.url = "github:sodiboo/niri-flake";
    home-manager.url = "github:nix-community/home-manager";
    helix.url = "github:helix-editor/helix";
    spbased.url = "github:lakrestofer/spbased";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    claude-code.url = "github:sadjow/claude-code-nix";
    sprite-cli.url = "github:jamiebrynes7/sprite-cli-nix";
  };
  outputs =
    {
      nixpkgs-unstable,
      nixos-hardware,
      flake-parts,
      ...
    }@inputs:

    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          # Optional: use external flake logic, e.g.
          # inputs.foo.flakeModules.default
        ];
        flake = {
          # Put your original flake attributes here.

          nixosConfigurations = {
            minji =
              let
                inherit (inputs) home-manager;
                system = "x86_64-linux";
                specialArgs = {
                  inputs = inputs;
                  system = system;

                  pkgs-unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                };
              in
              nixpkgs-unstable.lib.nixosSystem {
                system = system;
                specialArgs = {
                  inputs = inputs;
                  system = system;

                  pkgs-unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                };
                pkgs = import inputs.nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
                modules = [
                  inputs.niri.nixosModules.niri
                  ./hosts/minji # desktop
                  ./modules/common.nix # base configuration
                  ./modules/fincei.nix
                  ./modules/nix_settings.nix
                  ./modules/networking.nix
                  ./modules/media.nix
                  ./modules/graphical_session.nix
                  ./modules/games.nix
                  inputs.nixos-hardware.nixosModules.common-cpu-amd
                  inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
                  inputs.nixos-hardware.nixosModules.common-gpu-amd
                  inputs.nixos-hardware.nixosModules.common-hidpi
                  inputs.nixos-hardware.nixosModules.common-pc-ssd
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "home-manager.backup";

                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.users.fincei.imports = [
                      (import ./hosts/minji/home.nix)
                    ];
                  }
                ];
              };
            selbeiskami =
              let
                inherit (inputs) nixpkgs-unstable home-manager;
                system = "x86_64-linux";
                specialArgs = {
                  inputs = inputs;
                  system = system;

                  pkgs-unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                };

              in

              nixpkgs-unstable.lib.nixosSystem {
                system = system;
                specialArgs = specialArgs;
                pkgs = import inputs.nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
                modules = [
                  inputs.niri.nixosModules.niri
                  ./hosts/selbeiskami # thinkpad t14 gen 2 configuration
                  ./modules/common.nix # base configuration
                  ./modules/fincei.nix
                  ./modules/nix_settings.nix
                  ./modules/networking.nix
                  ./modules/media.nix
                  ./modules/graphical_session.nix

                  nixos-hardware.nixosModules.lenovo-thinkpad-t14
                  nixos-hardware.nixosModules.common-cpu-intel
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "home-manager.backup";

                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.users.fincei.imports = [
                      (import ./home.nix)
                    ];
                  }
                ];
              };
          };
        };
        systems = [
          # systems for which you want to build the `perSystem` attributes
          "x86_64-linux"
          # ...
        ];
        perSystem =
          { config, pkgs, ... }:
          {
            # Recommended: move all package definitions here.
            # e.g. (assuming you have a nixpkgs input)
            # packages.foo = pkgs.callPackage ./foo/package.nix { };
            # packages.bar = pkgs.callPackage ./bar/package.nix {
            #   foo = config.packages.foo;
            # };
          };
      }
    );

}
