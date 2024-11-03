{
  pkgs,
  config,
  ...
}: {
  home.file.".config/helix" = {
    source = ./configs;
    recursive = true;
  };


}
