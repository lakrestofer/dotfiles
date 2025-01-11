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
  walkerPath = "${configRoot}/walker";
  scriptPath = "${configRoot}/scripts";
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
  # xdg.configFile."hypr".source = linkConf hyprPath;
  xdg.configFile."hypr" = {
    source = ./home/hypr;
    recursive = true;
  };
  xdg.configFile."ghostty".source = linkConf ghosttyPath;
  xdg.configFile."alacritty".source = linkConf alacrittyPath;
  xdg.configFile."zathura".source = linkConf zathuraPath;
  xdg.configFile."walker".source = linkConf walkerPath;
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
    settings = { };
    extraConfig = ''
      ################
      ### MONITORS ###
      ################

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,highres,auto,auto


      ###################
      ### MY PROGRAMS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/

      # Set programs that you use
      $terminal = alacritty
      $menu = walker
      $browser = firefox-developer-edition

      #################
      ### AUTOSTART ###
      #################

      # exec-once = hypridle
      exec-once = swww-daemon
      exec-once = agsbar
      exec-once = walker --gapplication-service
      exec-once = systemctl --user start hyprpolkitagent
      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24

      #####################
      ### LOOK AND FEEL ###
      #####################

      # Refer to https://wiki.hyprland.org/Configuring/Variables/

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general {
          # gaps and border
          gaps_in = 3
          gaps_out = 3
          border_size = 2
          # layout
          layout = dwindle
          # border color
          col.active_border  = rgb(fabd2f)
          col.inactive_border = rgb(928374)
          # other options
          no_focus_fallback = true
          resize_on_border = true
          resize_on_border = false
          allow_tearing = false
      }

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration {
          rounding = 0
          active_opacity = 1.0
          inactive_opacity = 1.0

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1
              vibrancy = 0.1696
          }
      }

      group {
          auto_group = true

          groupbar {
              font_size = 8
          }
      }

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations {
          enabled = true

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = overshot, 0.05, 0.9, 0.1, 1.1
          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = windowsMove, 1, 1.49, overshot
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, overshot, slide
          animation = workspacesIn, 1, 1.0, overshot, slide
          animation = workspacesOut, 1, 1.0, overshot, slide
          animation = specialWorkspace, 1, 1.0, linear, fade
          first_launch_animation = false
      }


      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master {
          new_status = master
      }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc {
          disable_hyprland_logo = true
          force_default_wallpaper = 0
          # swallow_regex = ^zathura$
          # enable_swallow = true
          vrr = 1
          mouse_move_enables_dpms = true
          key_press_enables_dpms = true
          font_family = "CozetteHiDpi"
      }


      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input {
          kb_layout = us
          kb_variant = altgr-intl
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
              natural_scroll = false
          }
          repeat_rate = 50
          repeat_delay = 200
      }

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures {
          workspace_swipe = false
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }


      ###################
      ### KEYBINDINGS ###
      ###################

      # aliases
      $mainMod = SUPER

      # - Applications -
      bind = $mainMod, return, exec, uwsm app -- $terminal
      bind = $mainMod CTRL, return, exec, $terminal --command /home/fincei/.local/bin/notes.sh
      bind = $mainMod CTRL, J, exec, $terminal --command /home/fincei/.local/bin/daily.sh
      bind = $mainMod, W, exec, uwsm app -- $browser
      bind = $mainMod, space, exec, uwsm app -- $menu # application launcher
      bind = $mainMod SHIFT,P,exec,grim -g "$(slurp)" - | wl-copy

      # - Manage currently focused application -
      bind = $mainMod, Q, killactive,
      # - Manage hyprland - 
      # bind = $mainMod CTRL, Q, exit
      bind = $mainMod CTRL, Q, exec, uwsm stop
      # - Layout - 
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, F, fullscreen, # dwindle

      # - Navigation -
      # within workspace
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      bind = $mainMod, N, movefocus, l
      bind = $mainMod, E, movefocus, d
      bind = $mainMod, I, movefocus, u
      bind = $mainMod, O, movefocus, r
      # between workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      bind = $mainMod CTRL,N,workspace,-1 # Relative navigation
      bind = $mainMod CTRL,O,workspace,+1 # Relative navigation
      # within group
      bind = $mainMod CTRL ALT, N, changegroupactive, b
      bind = $mainMod CTRL ALT, O, changegroupactive, f

      # - Move windows -
      # on workspace
      bind = $mainMod SHIFT,N,movewindow,l
      bind = $mainMod SHIFT,E,movewindow,d
      bind = $mainMod SHIFT,I,movewindow,u
      bind = $mainMod SHIFT,O,movewindow,r
      bind = $mainMod ALT SHIFT,N,movewindoworgroup,l
      bind = $mainMod ALT SHIFT,E,movewindoworgroup,d
      bind = $mainMod ALT SHIFT,I,movewindoworgroup,u
      bind = $mainMod ALT SHIFT,O,movewindoworgroup,r
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      # between workspaces
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10
      bind = $mainMod SHIFT CTRL,N,movetoworkspace,-1
      bind = $mainMod SHIFT CTRL,O,movetoworkspace,+1
      # into/outof groups
      bind = $mainMod,G,togglegroup

      # - Resize windows - 
      binde = $mainMod ALT,N,resizeactive,-10 0
      binde = $mainMod ALT,E,resizeactive,0 10
      binde = $mainMod ALT,I,resizeactive,0 -10
      binde = $mainMod ALT,O,resizeactive,10 0

      # Scratchpad
      bind = $mainMod, S, togglespecialworkspace, special
      # bind = $mainMod SHIFT, S, movetoworkspace, special

      # Laptop multimedia keys for volume and LCD brightness
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

      # Requires playerctl
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # Ignore maximize requests from apps. You'll probably like this.
      windowrulev2 = suppressevent maximize, class:.*

      # Fix some dragging issues with XWayland
      # windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

      # "Smart gaps" / "No gaps when only workspace (not applied on special workspaces)"
      workspace = w[t1] s[false], gapsout:0, gapsin:0
      workspace = w[tg1] s[false], gapsout:0, gapsin:0
      workspace = f[1] s[false], gapsout:0, gapsin:0
      windowrulev2 = bordersize 0, floating:0, onworkspace:w[t1] s[false]
      windowrulev2 = rounding 0, floating:0, onworkspace:w[t1] s[false]
      windowrulev2 = bordersize 0, floating:0, onworkspace:w[tg1] s[false]
      windowrulev2 = rounding 0, floating:0, onworkspace:w[tg1] s[false]
      windowrulev2 = bordersize 0, floating:0, onworkspace:f[1] s[false]
      windowrulev2 = rounding 0, floating:0, onworkspace:f[1] s[false]

      # large gaps on special workspace
      workspace = s[true], gapsout:50
      # windowrulev2 = bordersize:3, onworkspace:s[true]
    '';
  };
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
  };
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
  };
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
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
