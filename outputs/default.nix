{
  kmonad,
  home-manager,
  nixpkgs,
  nixos-hardware,
  ...
}@inputs:
let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };

  genSpecialArgs = system: {
    inherit mylib;
    inherit inputs;
    inherit system;

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
  system = "x86_64-linux";
  specialArgs = (genSpecialArgs system);
in
{
  nixosConfigurations = {
    minji = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ../hosts/minji # desktop
        ../common.nix # base configuration
        home-manager.nixosModules.home-manager
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-hidpi
        nixos-hardware.nixosModules.common-pc-ssd
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fincei.imports = [
            (import ../hosts/minji/home.nix)
          ];
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };
    selbeiskami = mylib.nixosSystem {
      inherit system specialArgs;
      nixos-modules = [
        ../hosts/selbeiskami # thinkpad x220 specific configuration
        ../common.nix # base configuration
        kmonad.nixosModules.default
        nixos-hardware.nixosModules.lenovo-thinkpad-t14
      ];
      home-modules = [
        (import ../home.nix)
      ];
    };
  };
}
