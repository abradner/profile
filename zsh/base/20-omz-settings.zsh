# oh-my-zsh settings and the base plugin list. Other use cases append to
# `plugins` in their own 2x files; oh-my-zsh reads the array when it loads at 40.

# starship draws the prompt (70-tools). A theme left set here fights it for
# PROMPT and doubles the first prompt line after a completion.
ZSH_THEME=""
HYPHEN_INSENSITIVE=true
COMPLETION_WAITING_DOTS=true
DISABLE_UNTRACKED_FILES_DIRTY=true   # faster git status in big repos
HIST_STAMPS=yyyy-mm-dd

plugins=(
  git
  sudo
  command-not-found
  colored-man-pages
  extract
  copypath
  history
)
