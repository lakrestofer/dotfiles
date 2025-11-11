#!/usr/bin/env zsh

if [[ $ZSH_EVAL_CONTEXT != *:file ]]; then
  gum log --level error "Error: please source this script instead of running it:"
  gum log --level error "usage:  source $0 ./your_script_using_uv.py"
  return 1 2>/dev/null || exit 1
fi

env=$(uv python find --script "$1")
gum log --level info "Environment found: " "$env"
activate_path="${env%/*}/activate"

source "$activate_path"
