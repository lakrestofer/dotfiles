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
    monitor = [
      "HDMI-A-1,highres,-1080x-240,auto,transform,3"
      "DP-1,highres,0x0,auto"
      "DP-2,highres,2560x-240,auto,transform,1"
    ];
  };
}
