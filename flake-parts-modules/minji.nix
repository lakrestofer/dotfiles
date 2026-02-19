{ inputs, ... }:
{
  flake.nixosConfigurations.minji =
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
    inputs.nixpkgs-unstable.lib.nixosSystem {
      system = system;
      specialArgs = {
        inputs = inputs;
        system = system;

        pkgs-unstable = import inputs.nixpkgs-unstable {
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

}
