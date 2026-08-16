autoload -U promptinit; promptinit; 
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

autoload -U select-word-style
select-word-style bash

setopt auto_cd

# Prompt
eval "$(starship init zsh)"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt inc_append_history
setopt share_history

# Shell Theme
. ~/scripts/base16-tomorrow-night.sh

# Custom functions
function rm() {
  /bin/rm $@ -I
}

function hhm() {
  columns='columns=name,id,ipv4,type,age,status'
  if [ "$#" -eq 0 ]; then
    instance=$(hcloud server list -o "$columns" -o noheader | sort | fzf --height 40%)
  else
    instance=$(hcloud server list -o "$columns" -o noheader | sort | fzf --height 40% -1 -q "$@")
  fi
  if [ "$instance" != "" ]; then
    instance_id=$(echo $instance | awk '{print $2}')
    echo "Connecting to $instance_id"
    hcloud server ssh $instance_id
  fi
}

ssm() {
    query='Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value, InstanceId, PrivateIpAddress, InstanceType, LaunchTime, State.Name]'
    if [ "$#" -eq 0 ]; then
        instance=$(aws ec2 describe-instances --query "$query" --output table | sort | grep -f <(aws ssm describe-instance-information --query 'InstanceInformationList[].[InstanceId]' --output text) | fzf --height 40%)
    else
        instance=$(aws ec2 describe-instances --query "$query" --output table | sort | grep -f <(aws ssm describe-instance-information --query 'InstanceInformationList[].[InstanceId]' --output text) | fzf --height 40% -1 -q "$@")
    fi
    if [ "$instance" != "" ]; then
        instance_id=$(echo $instance | cut -d '|' -f 3)
        echo "Connecting to $instance"
        aws ssm start-session --target "${instance_id// /}"
    fi
}

select_ec2() {
  query='Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value, InstanceId, PrivateIpAddress, InstanceType, LaunchTime, State.Name]'
  if [ "$#" -eq 0 ]; then
      instance=$(aws ec2 describe-instances --query "$query" --output table | sort | grep -f <(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --output text) | fzf --height 40%)
  else
      instance=$(aws ec2 describe-instances --query "$query" --output table | sort | grep -f <(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --output text) | fzf --height 40% -1 -q "$@")
  fi
  echo $instance | cut -d '|' -f 3 | xargs
}

ec2-start() {
  instance_id=$(select_ec2 $@)
  if [ "$instance_id" != "" ]; then
    echo "Starting $instance_id"
    echo "Press <Ctrl>-<C> to abort or <Enter> to continue…" >&2
    read -r
    aws ec2 start-instances --instance-ids "$instance_id"
  fi
}

ec2-stop() {
  instance_id=$(select_ec2 $@)
  if [ "$instance_id" != "" ]; then
    echo "Stopping $instance_id"
    echo "Press <Ctrl>-<C> to abort or <Enter> to continue…" >&2
    read -r
    aws ec2 stop-instances --instance-ids "$instance_id"
  fi
}

select_rds() {
  query='DBInstances[].[DBInstanceIdentifier, Engine, DBInstanceClass, InstanceCreateTime, DBInstanceStatus]'
  if [ "$#" -eq 0 ]; then
    instance=$(aws rds describe-db-instances --query "$query" --output table | sort | grep -f <(aws rds describe-db-instances --query 'DBInstances[].[DBInstanceIdentifier]' --output text) | fzf --height 40%)
  else
    instance=$(aws rds describe-db-instances --query "$query" --output table | sort | grep -f <(aws rds describe-db-instances --query 'DBInstances[].[DBInstanceIdentifier]' --output text) | fzf --height 40% -1 -q "$@")
  fi
  echo $instance | cut -d '|' -f 2 | xargs
}

rds-start() {
  instance_id=$(select_rds $@)
  if [ "$instance_id" != "" ]; then
    echo "Starting $instance_id"
    echo "Press <Ctrl>-<C> to abort or <Enter> to continue…" >&2
    read -r
    aws rds start-db-instance --db-instance-identifier "$instance_id"
  fi
}

rds-stop() {
  instance_id=$(select_rds $@)
  if [ "$instance_id" != "" ]; then
    echo "Stopping $instance_id"
    echo "Press <Ctrl>-<C> to abort or <Enter> to continue…" >&2
    read -r
    aws rds stop-db-instance --db-instance-identifier "$instance_id"
  fi
}

select_asg() {
  query='AutoScalingGroups[].[AutoScalingGroupName, Instances[0].InstanceType || `n/a`, MinSize, DesiredCapacity, MaxSize, CreatedTime]'
  if [ "$#" -eq 0 ]; then
      asg=$(aws autoscaling describe-auto-scaling-groups --query "$query" --output table | sort | grep -f <(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].[AutoScalingGroupName]' --output text) | fzf --height 40%)
  else
      asg=$(aws autoscaling describe-auto-scaling-groups --query "$query" --output table | sort | grep -f <(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].[AutoScalingGroupName]' --output text) | fzf --height 40% -1 -q "$@")
  fi
  echo $asg | cut -d '|' -f 2 | xargs
}

autoscaling-start() {
  group_name=$(select_asg $@)
  if [ "$group_name" != "" ]; then
    echo "Starting $group_name"
    echo "Press <Ctrl>-<C> to abort or <Enter> to continue…" >&2
    read -r
    aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$group_name" --desired-capacity 1
  fi
}

autoscaling-stop() {
  group_name=$(select_asg $@)
  if [ "$group_name" != "" ]; then
    echo "Stopping $group_name"
    echo "Press <Ctrl>-<C> to abort or <Enter> to continue…" >&2
    read -r
    aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$group_name" --desired-capacity 0
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
alias ls="ls --color=auto"
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
alias serve="python -m http.server 8000"
alias k="kubectl"
alias rpi-k8s="export KUBECONFIG=~/.kube/config.rpi-k8s"
alias vim="nvim"
alias oc='env -i HOME="$HOME" PATH="$PATH" TERM="$TERM" USER="$USER" LANG="$LANG" srt opencode'

function dockerssh() {
  docker exec -it $(docker container ls | tail -n +2 | fzf | awk -F '   ' '{print $1}') /bin/bash
}

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

# Auto complete
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(kubectl completion zsh)
source /usr/share/fzf/key-bindings.zsh
complete -o nospace -C /usr/bin/terraform terraform
source /home/christian/.jfrog/jfrog_zsh_completion

# Local binaries
function addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

addToPathFront $HOME/go/bin/
addToPathFront $HOME/.local/bin/
addToPathFront $HOME/.local/scripts

export PATH=~/.npm-global/bin:$PATH

# Load local-specific configuration if present
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

