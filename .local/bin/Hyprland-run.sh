#!/bin/sh
export _JAVA_AWT_WM_NONREPARENTING=1
export XCURSOR_SIZE=24
export QT_QPA_PLATFORM="wayland;xcb"
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1 firefox
export XDG_CURRENT_DESKTOP=Unity
export XDG_SESSION_TYPE=wayland

# we check if the nvidia kernel module is loaded
dkms status | grep "nvidia" &> /dev/null

if [ $? -eq 0 ]; then
  export LIBVA_DRIVER_NAME=nvidia
  export GBM_BACKEND=nvidia-drm
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export WLR_NO_HARDWARE_CURSORS=1
fi

exec Hyprland
