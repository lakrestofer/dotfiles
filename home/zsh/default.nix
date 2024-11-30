{
  pkgs,
  config,
  ...
}: {
  home.file.".zshrc".source = ./zshrc.zsh;
  home.file.".zprofile".source = ./zprofile.zsh;
}
