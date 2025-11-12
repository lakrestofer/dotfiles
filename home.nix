{
  config,
  pkgs-unstable,
  inputs,
  ...
}:
let
  # paths
  configRoot = "${config.home.homeDirectory}/dotfiles/home";
  dataRoot = "${config.home.homeDirectory}/dotfiles/data";
  helixPath = "${configRoot}/helix";
  codebookPath = "${configRoot}/codebook";
  alacrittyPath = "${configRoot}/alacritty";
  qutePath = "${configRoot}/qutebrowser";
  ghosttyPath = "${configRoot}/ghostty";
  zathuraPath = "${configRoot}/zathura";
  waybarPath = "${configRoot}/waybar";
  hyprPath = "${configRoot}/hypr";
  makoPath = "${configRoot}/mako";
  fuzzelPath = "${configRoot}/fuzzel";
  niriPath = "${configRoot}/niri";
  swaylockPath = "${configRoot}/swaylock";
  scriptPath = "${configRoot}/scripts";
  emacsPath = "${configRoot}/emacs";
  lazygitPath = "${configRoot}/lazygit";
  yaziPath = "${configRoot}/yazi";
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
  ];
  # user packages (only installed per user)
  home.packages = [ ];
  xdg.configFile."swaylock".source = linkConf swaylockPath;
  xdg.configFile."helix".source = linkConf helixPath;
  xdg.configFile."codebook".source = linkConf codebookPath;
  xdg.configFile."hypr".source = linkConf hyprPath;
  xdg.configFile."ghostty".source = linkConf ghosttyPath;
  xdg.configFile."alacritty".source = linkConf alacrittyPath;
  xdg.configFile."zathura".source = linkConf zathuraPath;
  xdg.configFile."waybar".source = linkConf waybarPath;
  xdg.configFile."yazi".source = linkConf yaziPath;
  xdg.configFile."qutebrowser".source = linkConf qutePath;
  xdg.configFile."fuzzel".source = linkConf fuzzelPath;
  xdg.configFile."niri".source = linkConf niriPath;
  xdg.configFile."mako".source = linkConf makoPath;
  xdg.configFile."emacs".source = linkConf emacsPath;
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
      package = pkgs-unstable.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs-unstable.gruvbox-plus-icons;
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
