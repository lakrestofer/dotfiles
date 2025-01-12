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
  # minji specific hyprland config
  # 3 monitors with set sizes
  wayland.windowManager.hyprland.settings = {

  };
}
