{
  pkgs,
  config,
  ...
}: {
  home.file.".zshrc".source = ./zhsrc.zsh
}
