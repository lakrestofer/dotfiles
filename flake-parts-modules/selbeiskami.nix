{ inputs, self, ... }:
{
  flake.nixosConfigurations.selbeiskami =
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
        ../hosts/selbeiskami # thinkpad t14 gen 2 configuration
        self.nixosModules.commonModule
        self.nixosModules.usersModule
        self.nixosModules.graphicalSessionModule
        self.nixosModules.nixSettingsModule
        self.nixosModules.networkingModule
        self.nixosModules.mediaModule

        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "home-manager.backup";

          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.fincei.imports = [
            (import ../home.nix)
          ];
        }
      ];
    };
}
