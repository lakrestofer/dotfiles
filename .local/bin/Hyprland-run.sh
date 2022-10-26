#!/bin/sh
export _JAVA_AWT_WM_NONREPARENTING=1
export XCURSOR_SIZE=24
export QT_QPA_PLATFORM="wayland;xcb"
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1 firefox
export XDG_CURRENT_DESKTOP=Unity
exec Hyprland
