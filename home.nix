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
        no_fade_in = true
        no_fade_out = true
        hide_cursor = false
        grace = 0
        disable_loading_bar = true
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 1;
        }
      ];
      input-field = [
        {
          monitor =
          size = "200, 50"
          outline_thickness = 3
          dots_size = 0.33
          dots_spacing = 0.15
          dots_center = false
          dots_rounding = -1
          # outer_color = rgba(17, 17, 17, 1.0)
          inner_color = "rgba(200, 200, 200, 1.0)"
          font_color = "rgba(10, 10, 10, 1.0)"
          fade_on_empty = false
          placeholder_text = 
          hide_input = false
          # check_color = rgba(204, 136, 34, 1.0)
          # fail_color = rgba(204, 34, 34, 1.0) # if authentication failed, changes outer_color and fail message color
          fail_text =
          fail_timeout = 400 # milliseconds before fail_text and fail_color disappears
          fail_transition = 300 # transition time in ms between normal outer_color and fail_color
          capslock_color = "-1"
          numlock_color = "-1"
          bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false # change color if numlock is off
          swap_font_color = false # see below
          position = 0, 100
          halign = center
          valign = bottom
        }
      ];
    };
  };



  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-default";
      package = pkgs.gruvbox-gtk-theme;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };
}
