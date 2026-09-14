# User bins first so anything installed there wins. (N/) drops a directory
# that doesn't exist on this machine.
typeset -U path fpath
path=(
  $HOME/.local/bin
  $HOME/bin(N/)
  $HOME/.cargo/bin(N/)
  $HOME/.docker/bin(N/)
  $path
)

# Completion directories must be on fpath before oh-my-zsh runs compinit.
fpath=(
  $HOME/.zsh_functions(N/)
  $HOME/.zsh/completions(N/)
  $HOME/.docker/completions(N/)
  $fpath
)
