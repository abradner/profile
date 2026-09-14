# After oh-my-zsh, whose lib/history.zsh sets its own sizes and options.
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=50000
SAVEHIST=50000

# SHARE_HISTORY already appends incrementally; zsh warns against also setting
# INC_APPEND_HISTORY.
setopt SHARE_HISTORY EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY
