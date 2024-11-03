{ config, pkgs, ... }:

{
  # basic options
  home.username = "fincei";
  home.homeDirectory = "/home/fincei";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  # === applications ===
  # helix

  # git
  programs.git = {
    enable = true;
    userEmail = "lakrestofer@gmail.com";
    userName = "lakrestofer";
  }

}
