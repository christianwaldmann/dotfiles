# https://pastebin.com/raw/UWHMV2QF
# Command Prompt: Pure
autoload -U promptinit; promptinit; 

autoload -U compinit
compinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

autoload -U select-word-style
select-word-style bash

setopt auto_cd

prompt pure

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt inc_append_history
setopt share_history

# Shell Theme
. ~/repos/dotfiles/base16-shell/scripts/base16-tomorrow-night.sh

# Custom functions
function ls() 
{
  if [[ "$1" == -* ]]; then
    exa --colour-scale -bghla -snew $2
  else
    exa --colour-scale -bghla -snew $1
  fi
}

function mem() {
  echo $(echo $(smem -t -P $1 | tail -n 1 | rev | cut -d ' ' -f 2 | rev) / 1024 | bc) MB
}

gpr() {
  if [ $? -eq 0 ]; then
    github_url=`git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#http://#' -e 's@com:@com/@' -e 's%\.git$%%'`;
    branch_name=`git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3`;
    pr_url=$github_url"/compare/master..."$branch_name
    open $pr_url;
  else
    echo 'failed to open a pull request.';
  fi
}

# Alias
alias l="exa -bghl -snew"
alias ll="exa -bghl -snew"
alias top="htop"
alias eZ="vim ~/.zshrc"
alias eI="vim ~/.config/i3/config"
alias uZ="source ~/.zshrc"
alias dot="cd ~/repos/dotfiles"
alias history="history 0"
alias ..="cd .."
alias ...="cd ../.."
alias myip="curl http://ipecho.net/plain; echo"
alias usage='du -h -d1'

# Tmux Shortcuts
if test $TMUX; then
  bindkey '^[[1~'  beginning-of-line
  bindkey '^[[4~'  end-of-line
  bindkey '^[[3~'  delete-char
else
  bindkey '^[[H'  beginning-of-line
  bindkey '^[[F'  end-of-line
  bindkey '^[[3~'  delete-char
fi

