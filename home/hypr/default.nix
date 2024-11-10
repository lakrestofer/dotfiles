{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland.systemd.enable = true;
  home.file.".config/hypr" = {
    source = ./configs;
    recursive = true;
  };
}
