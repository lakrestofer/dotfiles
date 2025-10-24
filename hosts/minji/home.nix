{
  config,
  pkgs-unstable,
  inputs,
  ...
}:
{
  imports = [
    (import ../../home.nix {
      inherit config inputs;
      pkgs-unstable = pkgs-unstable;
    })
  ];
}
