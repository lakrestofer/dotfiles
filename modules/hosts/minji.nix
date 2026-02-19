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
            (import ../../home.nix)
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

  flake.nixosModules.minjiHardwareModule =
    {
      config,
      lib,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/f9e0c5b2-1604-4c65-9df8-164c5ac6229c";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/180A-78C5";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/060e6c72-ad91-4127-9222-899cac846fb2"; }
      ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

}
