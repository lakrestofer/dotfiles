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
      "DP-1,highres,0x0,auto" # main center monitor
      "DP-2,highres,2560x-240,auto,transform,1" # rotated 90 to the right
    ];
    workspace = [
      "1,monitor:DP-1"
      "2,monitor:DP-1"
      "3,monitor:DP-1"
      "4,monitor:DP-1"
      "5,monitor:DP-1"
      "6,monitor:DP-2"
      "7,monitor:DP-2"
      "8,monitor:DP-2"
      "9,monitor:DP-2"
      "0,monitor:DP-2"
      "10,monitor:DP-2"
      "11,monitor:HDMI-A-1"
      "12,monitor:HDMI-A-1"
      "13,monitor:HDMI-A-1"
      "14,monitor:HDMI-A-1"
      "15,monitor:HDMI-A-1"
    ];
  };
}
