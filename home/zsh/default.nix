{
  pkgs,
  config,
  ...
}: {
  home.file.".zshrc".source = ./zshrc.zsh;
}
