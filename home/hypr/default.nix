{
  pkgs,
  config,
  ...
}: {
  home.file.".config/hypr" = {
    source = ./configs;
    recursive = true;
  };


}