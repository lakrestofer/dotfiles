{
  kmonad,
  nixpkgs-unstable,
  nixos-hardware,
  ...
}@inputs:
let
  inherit (inputs.nixpkgs-unstable) lib;
  mylib = import ./lib { inherit lib; };

  genSpecialArgs = system: {
    inherit mylib;
    inherit inputs;
    inherit system;

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  args = {
    inherit
      inputs
      lib
      genSpecialArgs
      ;
  };

in
{
  nixosConfigurations = {
    minji = mylib.nixosSystem (
      args
      // {
        system = "x86_64-linux";
        nixos-modules = [
          inputs.niri.nixosModules.niri
          ./hosts/minji # desktop
          ./modules/common.nix # base configuration
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-hidpi
          nixos-hardware.nixosModules.common-pc-ssd
        ];
        home-modules = [
          (import ./hosts/minji/home.nix)
        ];
      }
    );
    selbeiskami = mylib.nixosSystem (
      args
      // {
        system = "x86_64-linux";
        nixos-modules = [
          inputs.niri.nixosModules.niri
          ./hosts/selbeiskami # thinkpad x220 specific configuration
          ./modules/common.nix # base configuration
          kmonad.nixosModules.default
          nixos-hardware.nixosModules.lenovo-thinkpad-t14
          nixos-hardware.nixosModules.common-cpu-intel
        ];
        home-modules = [
          (import ./home.nix)
        ];
      }
    );
  };
}
