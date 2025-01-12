{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    (import ../../home.nix { inherit config pkgs inputs; })
  ];

}
