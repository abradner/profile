# fzf >= 0.48 prints its own integration; older Debian packages ship the
# scripts under /usr/share/doc instead.
if (( $+commands[fzf] )); then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  else
    for _profile_f in /usr/share/doc/fzf/examples/{key-bindings,completion}.zsh(N); do
      source $_profile_f
    done
    unset _profile_f
  fi
fi

(( $+commands[mise] )) && eval "$(mise activate zsh)"

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  # Bare-box fallback: user@host:dir, # for root.
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%(!.#.$) '
fi
