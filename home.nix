{ config, pkgs, ... }:

{
  # basic options
  home.username = "fincei";
  home.homeDirectory = "/home/fincei";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  # load application specific configuration files
  imports = [
    ./home/helix
    ./home/hypr
    ./home/zsh
    ./home/alacritty
  ];
  # user packages (only installed per user)
  home.packages = with pkgs; [];

  programs.zoxide = {
    enable = true;
  };

  # git
  programs.git = {
    enable = true;
    userEmail = "lakrestofer@gmail.com";
    userName = "lakrestofer";
  };



}
