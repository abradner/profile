# Order matters where plugins define the same alias: the later one wins
# (tmux and tailscale both want `ts`; tailscale keeps it, as before).
plugins+=(
  docker docker-compose kubectl terraform
  tmux ssh tailscale
  bundler rails ruby
  yarn npm node
  alias-finder virtualenv
)
