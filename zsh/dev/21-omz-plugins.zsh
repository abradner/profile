# Order matters where plugins define the same alias: the later one wins
# (tmux and tailscale both want `ts`; tailscale keeps it, as before).
plugins+=(
  docker docker-compose kubectl microk8s terraform
  tmux ssh tailscale
  bundler rails ruby kamal
  yarn npm node
  mvn gradle
  alias-finder colorize web-search virtualenv
  vscode 1password
)

# Left out: bun (with mise shims on PATH it errors on every start in a
# directory without bun) and mise (70-tools already activates it).

# thefuck's plugin prints an install nag when the tool is missing.
(( $+commands[thefuck] )) && plugins+=(thefuck)
