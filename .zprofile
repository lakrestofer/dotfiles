export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin/status_bar"
export PATH="$PATH:$HOME/.local/rofi"

export EDITOR="helix"
export TERMINAL="alacritty"
export BROWSER="brave"

# If not using a display manager (login) then the below can be used to automatically
# start a graphical session on login.
if [ -z "${DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland-run.sh
fi
