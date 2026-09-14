# oh-my-zsh when it's installed; otherwise plain completion, so base still
# works on a bare box (appliances, root accounts).
export ZSH=${ZSH:-$HOME/.oh-my-zsh}
if [[ -r $ZSH/oh-my-zsh.sh ]]; then
  source $ZSH/oh-my-zsh.sh
else
  autoload -Uz compinit && compinit
fi
