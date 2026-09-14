# Find aliases by pattern: za docker
za() {
  alias | grep -- "$*"
}

# Show a stash as a patch: gstsp 2
gstsp() {
  git stash show -p "stash@{${1:-0}}"
}

# cd, then list
cx() {
  builtin cd "$@" || return
  if (( $+commands[lsd] )); then lsd -la; else ls -la; fi
}

mkcd() {
  mkdir -p "$1" && builtin cd "$1"
}

# Kill whatever listens on a port: killport 3000
killport() {
  (( $+commands[lsof] )) || { echo "killport: lsof not installed" >&2; return 1; }
  local pids
  pids=$(lsof -ti:"$1") || { echo "killport: nothing on port $1" >&2; return 1; }
  kill -9 ${(f)pids}
}

zshconfig() {
  ${=EDITOR:-nano} ~/.zshrc
}

zshreload() {
  source ~/.zshrc && echo "zsh configuration reloaded"
}
