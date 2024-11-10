{
  pkgs,
  config,
  ...
}: {
  home.file.".config/alacritty" = {
    source = ./configs;
    recursive = true;
  };
}
