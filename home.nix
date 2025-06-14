{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # paths
  configRoot = "${config.home.homeDirectory}/dotfiles/home";
  dataRoot = "${config.home.homeDirectory}/dotfiles/data";
  helixPath = "${configRoot}/helix";
  alacrittyPath = "${configRoot}/alacritty";
  ghosttyPath = "${configRoot}/ghostty";
  zathuraPath = "${configRoot}/zathura";
  waybarPath = "${configRoot}/waybar";
  hyprPath = "${configRoot}/hypr";
  tofiPath = "${configRoot}/tofi";
  scriptPath = "${configRoot}/scripts";
  emacsPath = "${configRoot}/emacs";
  walkerPath = "${configRoot}/walker";
  lazygitPath = "${configRoot}/lazygit";
  zshRoot = "${configRoot}/zsh";
  # function aliases
  linkConf = config.lib.file.mkOutOfStoreSymlink;
  system = "x86_64-linux";
in
{
  # basic options
  home.username = "fincei";
  home.homeDirectory = "/home/fincei";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true; # allow home manager to manage itself
  # imports
  imports = [
    # ./home/zsh
    ./wallpaper
  ];
  # user packages (only installed per user)
  home.packages = [ ];
  xdg.configFile."helix".source = linkConf helixPath;
  xdg.configFile."hypr".source = linkConf hyprPath;
  xdg.configFile."ghostty".source = linkConf ghosttyPath;
  xdg.configFile."alacritty".source = linkConf alacrittyPath;
  xdg.configFile."zathura".source = linkConf zathuraPath;
  xdg.configFile."waybar".source = linkConf waybarPath;
  xdg.configFile."tofi".source = linkConf tofiPath;
  xdg.configFile."emacs".source = linkConf emacsPath;
  xdg.configFile."walker".source = linkConf walkerPath;
  xdg.configFile."lazygit".source = linkConf lazygitPath;
  xdg.dataFile."fincei_data".source = linkConf dataRoot;
  home.file.".local/bin".source = linkConf scriptPath;
  home.file.".zshrc".source = linkConf "${zshRoot}/zshrc.zsh";
  home.file.".zprofile".source = linkConf "${zshRoot}/zprofile.zsh";
  home.file.".p10k.zsh".source = linkConf "${zshRoot}/p10k.zsh";

  # git
  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "lakrestofer@gmail.com";
    userName = "lakrestofer";
  };

  # hyprland and friends
  # programs.hyprlock = {
  #   enable = true;
  #   package = pkgs.hyprlock;
  # };
  # services.hypridle = {
  #   enable = true;
  #   package = pkgs.hypridle;
  # };
  # notification service
  services.mako = {
    enable = true;
  };
  # Systemwide application themeing
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "gtk2";
    };
  };
  gtk = {
    enable = true;
    font.name = "CozetteHiDpi Medium 10";
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
