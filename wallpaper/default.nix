{
  config,
  ...
}:
let
  wallpaperRoot = "${config.home.homeDirectory}/dotfiles/wallpaper";
  linkConf = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file."wallpaper.png".source = linkConf "${wallpaperRoot}/nixos_flake.png";
  # home.file."wallpaper.png".source = linkConf "${wallpaperRoot}/artificial-brain.png";
}
