# A GUI editor only when there's a local display to open it on; over SSH (or
# when VS Code isn't installed) `git commit` and friends get nano.
_profile_local_display=0
if [[ -z $SSH_CONNECTION ]]; then
  if [[ $PROFILE_OS == darwin || -n $DISPLAY || -n $WAYLAND_DISPLAY ]]; then
    _profile_local_display=1
  fi
fi

if (( _profile_local_display && $+commands[code] )); then
  export EDITOR='code -w'
else
  export EDITOR=nano
fi
unset _profile_local_display
