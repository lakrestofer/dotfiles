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
    ./home/scripts
    ./home/alacritty
  ];
  # user packages (only installed per user)
  home.packages = with pkgs; [];

  # git
  programs.git = {
    enable = true;
    userEmail = "lakrestofer@gmail.com";
    userName = "lakrestofer";
  };

  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    settings = {
      general = {
        no_fade_in = true;
        no_fade_out = true;
        hide_cursor = false;
        grace = 0;
        disable_loading_bar = true;
      };
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 2;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = false;
          dots_rounding = -1;
          inner_color = "rgba(200, 200, 200, 1.0)";
          font_color = "rgba(10, 10, 10, 1.0)";
          fade_on_empty = false;
          hide_input = false;
          fail_timeout = 400;
          fail_transition = 300;
          capslock_color = "-1";
          numlock_color = "-1";
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, 100";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
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
    plattformTheme.name = "gtk";
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
