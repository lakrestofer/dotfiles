export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:$HOME/.cargo/bin"


export EDITOR="helix"
export VISUAL="helix"
export TERMINAL="alacritty"
export BROWSER="firefox-developer-edition"

# If not using a display manager (login) then the below can be used to automatically
# start a graphical session on login.
if [ -z "${DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland-run.sh
fi


