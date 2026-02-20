{ inputs, self, ... }:
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

        self.nixosModules.minjiModule
        self.nixosModules.minjiHardwareModule

        self.nixosModules.commonModule
        self.nixosModules.usersModule
        self.nixosModules.nixSettingsModule
        self.nixosModules.networkingModule
        self.nixosModules.mediaModule
        self.nixosModules.graphicalSessionModule
        self.nixosModules.gamesModule

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
            self.homeModules.finceiModule
          ];
        }
      ];
    };

  flake.nixosModules.minjiModule =
    { inputs, pkgs, ... }:
    {
      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      boot.loader.efi.canTouchEfiVariables = true;
      # hardware.amdgpu.opencl.enable = true;

      # programs.adb.enable = true;

      networking.hostName = "minji"; # Define your hostname.

      boot.initrd.kernelModules = [
        "amdgpu"
      ];

      hardware.enableRedistributableFirmware = true;

    };
}
