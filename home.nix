{
  inputs,
  config,
  pkgs,
  ...
}:
let
  # paths
  configRoot = "${config.home.homeDirectory}/dotfiles/home";
  helixPath = "${configRoot}/helix";
  hyprPath = "${configRoot}/hypr";
  alacrittyPath = "${configRoot}/alacritty";
  ghosttyPath = "${configRoot}/ghostty";
  zathuraPath = "${configRoot}/zathura";
  scriptPath = "${configRoot}/scripts";
  # function aliases
  linkConf = config.lib.file.mkOutOfStoreSymlink;
in
{
  # basic options
  home.username = "fincei";
  home.homeDirectory = "/home/fincei";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  # imports
  imports = [
    inputs.walker.homeManagerModules.default
    ./home/zsh
    ./home/wallpaper.nix
  ];
  # user packages (only installed per user)
  home.packages = [ ];
  xdg.configFile."helix".source = linkConf helixPath;
  xdg.configFile."hypr".source = linkConf hyprPath;
  xdg.configFile."ghostty".source = linkConf ghosttyPath;
  xdg.configFile."alacritty".source = linkConf alacrittyPath;
  xdg.configFile."zathura".source = linkConf zathuraPath;
  home.file.".local/bin".source = linkConf scriptPath;

  # often changed dotfils

  # git
  programs.git = {
    enable = true;
    userEmail = "lakrestofer@gmail.com";
    userName = "lakrestofer";
  };

  programs.walker = {
    enable = true;
    runAsService = true;

    # All options from the config.json can be used here.
    config = {
      search.placeholder = ">";
      ui.fullscreen = true;
      list = {
        height = 200;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
    };

    # If this is not set the default styling is used.
    style = ''
      * {
        color: #dcd7ba;
      }
    '';
  };

  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
  };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Gruvbox-B-MB";
  #     package = pkgs.gruvbox-gtk-theme;
  #   };
  #   gtk3 = {
  #     extraConfig.gtk-application-prefer-dark-theme = true;
  #   };

  # };
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
  services.mako = {
    enable = true;
  };
}
