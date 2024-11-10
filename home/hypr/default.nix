{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
    ################
    ### MONITORS ###
    ################

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor=,preferred,auto,auto


    ###################
    ### MY PROGRAMS ###
    ###################

    # See https://wiki.hyprland.org/Configuring/Keywords/

    # Set programs that you use
    $terminal = alacritty
    $menu = wofi --show drun
    $browser = firefox-devedition


    #################
    ### AUTOSTART ###
    #################

    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    # Or execute your favorite apps at launch like this:

    # exec-once = $terminal
    # exec-once = nm-applet &
    # exec-once = waybar & hyprpaper & firefox


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
        gaps_in = 4
        gaps_out = 2
        border_size = 1
        # layout
        layout = dwindle
        # border color
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
        # other options
        no_focus_fallback = false
        resize_on_border = true
        resize_on_border = false
        allow_tearing = false
    }

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration {
        rounding = 2
        active_opacity = 1.0
        inactive_opacity = 1.0

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur {
            enabled = true
            size = 3
            passes = 1
            vibrancy = 0.1696
        }
    }

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations {
        enabled = yes, please :)

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

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
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 1.94, almostLinear, fade
        animation = workspacesIn, 1, 1.21, almostLinear, fade
        animation = workspacesOut, 1, 1.94, almostLinear, fade
    }

    # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
    # "Smart gaps" / "No gaps when only"
    # uncomment all if you wish to use that.
    # workspace = w[t1], gapsout:0, gapsin:0
    # workspace = w[tg1], gapsout:0, gapsin:0
    # workspace = f[1], gapsout:0, gapsin:0
    # windowrulev2 = bordersize 0, floating:0, onworkspace:w[t1]
    # windowrulev2 = rounding 0, floating:0, onworkspace:w[t1]
    # windowrulev2 = bordersize 0, floating:0, onworkspace:w[tg1]
    # windowrulev2 = rounding 0, floating:0, onworkspace:w[tg1]
    # windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
    # windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

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
        force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
    }


    #############
    ### INPUT ###
    #############

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

        touchpad {
            natural_scroll = false
        }
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
    bind = $mainMod, return, exec, $terminal
    bind = $mainMod, W, exec, $browser
    bind = $mainMod, space, exec, $menu # application launcher

    # - Manage currently focused application -
    bind = $mainMod, Q, killactive,
    # - Manage hyprland - 
    bind = $mainMod CTRL, Q, exit,
    # - Layout - 
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle

    # - Navigation -
    # within workspace
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d
    bind = $mainMod, N, movefocus, l
    bind = $mainMod, E, movefocus, r
    bind = $mainMod, I, movefocus, u
    bind = $mainMod, O, movefocus, d
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

    # - Move windows -
    # on workspace
    bind = $mainMod SHIFT,N,movewindow,l
    bind = $mainMod SHIFT,E,swapnext,prev
    bind = $mainMod SHIFT,I,swapnext,next
    bind = $mainMod SHIFT,O,movewindow,r
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

    # - Resize windows - 
    binde = SUPERALT,N,resizeactive,-10 0
    binde = SUPERALT,E,resizeactive,0 10
    binde = SUPERALT,I,resizeactive,0 -10
    binde = SUPERALT,O,resizeactive,10 0

    # Example special workspace (scratchpad)
    #bind = $mainMod, S, togglespecialworkspace, magic
    #bind = $mainMod SHIFT, S, movetoworkspace, special:magic

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
    windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    '';
  };
  # home.file.".config/hypr" = {
  #   source = ./configs;
  #   recursive = true;
  # };
}
