alias home="ssh $* mordor.asn.au"

alias ls="ls -G"
alias la="ls -aG"
alias ll="ls -lG"

alias myip="ifconfig | grep -B3 inet\ "
alias prep_db="rake db:migrate db:test:prepare"
alias clean_db="rake db:migrate db:setup db:seed db:populate"
alias rs="rails s -b 0.0.0.0"
alias mod_cop="git status --porcelain | cut -c4- | grep '.rb' | xargs rubocop -a"

alias autoproxy='autossh -M 23456 -C -D *:2001 -L *:3128:localhost:3128'

alias brb='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'
alias http='ruby -run -e httpd -- --port 9999 .'

PS1='\[\033[01;33m\](\t)${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\u@\h\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\$ '

export PATH=${PATH}:~/bin

 [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# set the number of open files to be 1024
ulimit -S -n 1024


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
