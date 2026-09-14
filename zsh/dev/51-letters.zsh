# Single-letter aliases. Letters that shadowed a real command or exited the
# shell on a typo are gone: q/x (exit), w (the `w` command), r (zsh's
# repeat-last-command builtin), s/u/i (spring/up/iex, all dead). lazygit moved
# from `l` to `lg` so oh-my-zsh's `l` (ls -lah) survives.
alias b='bundle'
alias c='clear'
alias d='docker'
alias dc='docker-compose'
alias f='fzf'
alias g='git'
alias h='history'
alias j='jobs'
alias k='kubectl'
alias lg='lazygit'
alias m='make'
alias n='npm'
alias t='byobu'
alias v='vim'
alias y='yarn'
(( $+commands[python] )) && alias p='python' || alias p='python3'
(( $+commands[code] )) && alias e='code'

# List every single-letter alias, for when they aren't top of mind.
alias qc='alias | grep "^[a-z]="'
