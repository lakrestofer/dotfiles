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
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-1,highres,-1080x-240,auto,transform,3" # rotated 90 to the left
      "DP-1,highres,2560x-240,auto,transform,1" # rotated 90 to the right
      "DP-2,highres,0x0,auto" # main center monitor
    ];
    workspace = [
      "1,monitor:HDMI-A-1"
      "2,monitor:HDMI-A-1"
      "3,monitor:HDMI-A-1"
      "4,monitor:HDMI-A-1"
      "5,monitor:HDMI-A-1"
      "6,monitor:DP-2"
      "7,monitor:DP-2"
      "8,monitor:DP-2"
      "9,monitor:DP-2"
      "0,monitor:DP-2"
      "10,monitor:DP-1"
      "11,monitor:DP-1"
      "12,monitor:DP-1"
      "13,monitor:DP-1"
      "14,monitor:DP-1"
      "15,monitor:DP-1"
    ];
  };
}
