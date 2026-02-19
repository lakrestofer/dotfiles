{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    (import ../../home.nix {
      inherit config inputs;
      pkgs = pkgs;
    })
  ];
}
