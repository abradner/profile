# Safe everywhere: each alias only exists when its tool does.

if (( $+commands[lsd] )); then
  alias ls='lsd'
  alias ll='lsd -la'
  alias la='lsd -A'
  alias lt='lsd --tree --depth 2'
else
  alias ll='ls -la'
  alias la='ls -A'
fi

# Debian ships bat as `batcat` to avoid a name clash.
(( ! $+commands[bat] && $+commands[batcat] )) && alias bat='batcat'

(( $+commands[prettyping] )) && alias ping='prettyping --nolegend'

# Parallel gzip tar helpers:
#   tpc archive.tar.gz folder/   create
#   tpx archive.tar.gz           extract
if (( $+commands[pigz] )); then
  alias tpc='tar -I pigz -cvf'
  alias tpx='tar -I pigz -xvf'
  alias tgz='tar --use-compress-program=pigz'
fi

alias px='ps aux | grep'
alias biggest_files='du -hs * | sort -hr'
