
{
  pkgs,
  config,
  ...
}: {
  home.file.".local/bin" = {
      source = ./scripts;
      recursive = true;
  };
}
