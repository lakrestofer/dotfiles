{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [ ],
  ...
}@args:
let
  inherit (inputs) nixpkgs-unstable home-manager;
  specialArgs = (genSpecialArgs system);
in
nixpkgs-unstable.lib.nixosSystem {
  inherit system specialArgs;
  pkgs = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  modules =
    nixos-modules
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager.backup";

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.fincei.imports = home-modules;
      }
    ]);
}
