{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # paths
  configRoot = "${config.home.homeDirectory}/dotfiles/home";
  helixPath = "${configRoot}/helix";
  alacrittyPath = "${configRoot}/alacritty";
  ghosttyPath = "${configRoot}/ghostty";
  zathuraPath = "${configRoot}/zathura";
  waybarPath = "${configRoot}/waybar";
  tofiPath = "${configRoot}/tofi";
  scriptPath = "${configRoot}/scripts";
  emacsPath = "${configRoot}/emacs";
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
    ./home/zsh
    ./wallpaper
  ];
  # user packages (only installed per user)
  home.packages = [ ];
  xdg.configFile."helix".source = linkConf helixPath;
  xdg.configFile."hypr" = {
    source = ./home/hypr;
    recursive = true;
  };
  xdg.configFile."ghostty".source = linkConf ghosttyPath;
  xdg.configFile."alacritty".source = linkConf alacrittyPath;
  xdg.configFile."zathura".source = linkConf zathuraPath;
  xdg.configFile."waybar".source = linkConf waybarPath;
  xdg.configFile."tofi".source = linkConf tofiPath;
  xdg.configFile."emacs".source = linkConf emacsPath;
  home.file.".local/bin".source = linkConf scriptPath;

  # git
  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "lakrestofer@gmail.com";
    userName = "lakrestofer";
  };

  # hyprland and friends
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    systemd.variables = [ "--all" ];
    settings = {
      ################
      ### MONITORS ###
      ################
      monitor = [ ",highres,auto,1" ];
      ###################
      ### MY PROGRAMS ###
      ###################
      "$terminal" = "alacritty";
      "$menu" =
        "tofi-drun --font ${pkgs.cozette}/share/fonts/truetype/CozetteVector.ttf --late-keyboard-init=true";
      "$browser" = "brave";
      #################
      ### AUTOSTART ###
      #################
      "exec-once" = [
        "swww-daemon"
        "waybar"
        "systemctl --user start hyprpolkitagent"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
      ];
      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      #####################
      ### LOOK AND FEEL ###
      #####################
      general = {
        # gaps and border
        gaps_in = 3;
        gaps_out = 3;
        border_size = 2;
        # layout
        layout = "dwindle";
        # border color
        "col.active_border" = "rgb(fabd2f)";
        "col.inactive_border" = "rgb(928374)";
        # other options
        no_focus_fallback = true;
        resize_on_border = false;
        allow_tearing = false;
      };
      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      group = {
        auto_group = true;
        groupbar = {
          font_size = 8;
        };
      };
      # animations
      animations = {
        enabled = "true";
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "windowsMove, 1, 1.49, overshot"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, overshot, slide"
          "workspacesIn, 1, 1.0, overshot, slide"
          "workspacesOut, 1, 1.0, overshot, slide"
          "specialWorkspace, 1, 1.0, linear, fade"
        ];
        first_launch_animation = "false";
      };
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };
      master = {
        new_status = "master";
      };
      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        vrr = 1;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        # font_family = "CozetteHiDpi";
      };
      #############
      ### INPUT ###
      #############
      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
        repeat_rate = 50;
        repeat_delay = 200;
      };
      gestures = {
        workspace_swipe = false;
      };
      ###################
      ### KEYBINDINGS ###
      ###################
      # aliases
      "$mainMod" = "SUPER";
      bind = [
        # - Applications -
        "$mainMod, return, exec, uwsm app -- $terminal"
        "$mainMod CTRL, E, exec, emacs"
        "$mainMod CTRL, return, exec, $terminal --command /home/fincei/.local/bin/notes.sh"
        "$mainMod CTRL, J, exec, $terminal --command /home/fincei/.local/bin/journal.sh"
        "$mainMod, W, exec, uwsm app -- $browser"
        "$mainMod, space, exec, $menu"
        ''$mainMod SHIFT,P,exec,grim -g "$(slurp)" - | wl-copy''
        # - Manage currently focused application -
        "$mainMod, Q, killactive,"
        # - Manage hyprland -
        "$mainMod CTRL, Q, exec, uwsm stop"
        # - Layout -
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, F, fullscreen,"
        # - Navigation -
        # within workspace
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, N, movefocus, l"
        "$mainMod, E, movefocus, d"
        "$mainMod, I, movefocus, u"
        "$mainMod, O, movefocus, r"
        # between workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod CTRL,N,workspace,-1" # Relative navigation
        "$mainMod CTRL,O,workspace,+1" # Relative navigation
        # within group
        "$mainMod CTRL ALT, N, changegroupactive, b"
        "$mainMod CTRL ALT, O, changegroupactive, f"
        # - Move windows -
        # on workspace
        "$mainMod SHIFT,N,movewindow,l"
        "$mainMod SHIFT,E,movewindow,d"
        "$mainMod SHIFT,I,movewindow,u"
        "$mainMod SHIFT,O,movewindow,r"
        "$mainMod ALT SHIFT,N,movewindoworgroup,l"
        "$mainMod ALT SHIFT,E,movewindoworgroup,d"
        "$mainMod ALT SHIFT,I,movewindoworgroup,u"
        "$mainMod ALT SHIFT,O,movewindoworgroup,r"
        # between workspaces
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod SHIFT CTRL,N,movetoworkspace,-1"
        "$mainMod SHIFT CTRL,O,movetoworkspace,+1"
        # into/outof groups
        "$mainMod,G,togglegroup"
        # Scratchpad
        "$mainMod, S, togglespecialworkspace, special"
        "$mainMod SHIFT, S, movetoworkspacesilent, special"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      binde = [
        # - Resize windows -
        "$mainMod ALT,N,resizeactive,-10 0"
        "$mainMod ALT,E,resizeactive,0 10"
        "$mainMod ALT,I,resizeactive,0 -10"
        "$mainMod ALT,O,resizeactive,10 0"
      ];
      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      ##############################
      ### WINDOW AND WORKSPACE RULES ###
      ##############################
      windowrulev2 = [
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"
        # "Smart gaps" / "No gaps when only workspace (not applied on special workspaces)"
        "bordersize 0, floating:0, onworkspace:w[t1] s[false]"
        "rounding 0, floating:0, onworkspace:w[t1] s[false]"
        "bordersize 0, floating:0, onworkspace:w[tg1] s[false]"
        "rounding 0, floating:0, onworkspace:w[tg1] s[false]"
        "bordersize 0, floating:0, onworkspace:f[1] s[false]"
        "rounding 0, floating:0, onworkspace:f[1] s[false]"
      ];
      workspace = [
        # "Smart gaps" / "No gaps when only workspace (not applied on special workspaces)"
        "w[t1] s[false], gapsout:0, gapsin:0"
        "w[tg1] s[false], gapsout:0, gapsin:0"
        "f[1] s[false], gapsout:0, gapsin:0"
        # large gaps on special workspace
        "s[true], gapsout:50"
      ];
      layerrule = [
        "noanim, ^(tofi)$"
      ];
    };
  };
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
