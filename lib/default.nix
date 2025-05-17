{ lib, ... }:
{
  nixosSystem = import ./nixosSystem.nix;
  relativeToRoot = lib.path.append ../.;
}
