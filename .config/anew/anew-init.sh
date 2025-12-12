export GPG_TTY=$(tty)
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim

alias k=kubectl
alias t=tanzu
alias vi=nvim
alias vim=nvim
alias python=python3
alias pip=pip3

alias gpra='git pull --rebase --autostash'
alias gs='git status'
alias gl='git config --global alias.gl "log --all --decorate --graph --format=\"%C(auto)%h%d %s %C(blue)(%an)%C(reset)\""'
alias gls='git log --all --decorate --graph --oneline'
alias vd='vimdiff'
alias tf='terraform'
alias batl='bat --paging=never'  # no pager for shorties
alias cat='bat'
alias catp='bat -p'  # plain output
alias batless='bat'  # with pager
alias batp='bat -p'  # plain, no decorations
alias cat='bat'
alias ls='eza --icons'
alias ll='eza -lh --icons'
alias la='eza -lah --icons'
alias lt='eza --tree --icons'
alias find='fd'
alias grep='rg'
alias top='btop'
alias df='duf'
alias zz='z -'


gd() {
  if [ "$#" -eq 0 ]; then
    git diff
  else
    git diff "$*"
  fi
}

gcm-() {
  if [ "$#" -eq 0 ]; then
    git commit
  else
    git commit -m "$*"
  fi
}

cd() {
    builtin cd "$@" || return

    [[ "$1" =~ "^\\.\\." ]] && return

    while [[ $(ls -A | wc -l) -eq 1 ]] && [[ -d "$(ls -A)" ]]; do
        builtin cd "$(ls -A)"
        echo "→ $(pwd)"
    done
}

gcm() {
    git status --short
    echo ''

    # Pick from recent commit messages or type new
    msg=$(git log --format=%s -n 20 | fzf --print-query --prompt="Commit message: " | tail -1)

    git commit -m "$msg"
}

gscm() {
    # Select files to add
    git status --short | fzf -m --preview 'git diff --color=always {2}' | awk '{print $2}' | xargs git add

    git status --short
    echo ''
    read "msg?Commit message: "
    git commit -m "$msg"
}

events_in_namespace(){
    k get events --sort-by=".lastTimestamp" -n $1
}

awscreds(){
    #!/bin/bash
    declare awsCreds=`pbpaste | sed 's/ export//'`
    declare output="[default]\n" # start with profile name, or adjust function to take a variable
    for line in $awsCreds; do
        output+="$line\n";
    done
    printf $output > ~/.aws/credentials
}

change_git_author(){
  git commit --amend --author="Author Name <email@address.com>" --no-edit
}

yaml() {
  #VALUE=$(yaml ~/my_yaml_file.yaml "['a_key']")
  python3 -c "import yaml;print(yaml.safe_load(open('$1'))$2)"
}

use(){
    kubectl config use-context $1
}

dw(){
    local current="$(kubectl config current-context)"
    local currentNamespace="$(kubectl config get-contexts "$current" | awk "/$current/ {print \$5}")"
    tanzu apps workload delete -f config/workload.yaml --namespace $currentNamespace --yes
}

aw(){
    local current="$(kubectl config current-context)"
    local currentNamespace="$(kubectl config get-contexts "$current" | awk "/$current/ {print \$5}")"
    tanzu apps workload apply -f config/workload.yaml --namespace $currentNamespace --yes
}

mergeConfigs(){
    # https://support.tools/post/merge_kubeconfig_files
    cp ~/.kube/config ~/.kube/config_bk && KUBECONFIG=~/.kube/config:$1 kubectl config view --flatten > ~/.kube/config_tmp && mv ~/.kube/config_tmp ~/.kube/config
}

set-hostname() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: set-hostname <hostname> [domain]"
    echo "Example: set-hostname macbook andrewnewdigate.net"
    return 1
  fi

  local short_name="$1"
  local domain="${2:-}"
  local fqdn="${short_name}"

  if [[ -n "$domain" ]]; then
    fqdn="${short_name}.${domain}"
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Setting macOS hostname to: $fqdn"
    sudo scutil --set HostName "$fqdn"
    sudo scutil --set LocalHostName "$short_name"
    sudo scutil --set ComputerName "$short_name"
    sudo dscacheutil -flushcache
    echo "Done! Restart your terminal for changes to take effect."
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    echo "Setting Linux hostname to: $fqdn"
    sudo hostnamectl set-hostname "$fqdn"
    # Update /etc/hosts
    sudo sed -i.bak "s/127.0.1.1.*/127.0.1.1\t$fqdn $short_name/" /etc/hosts
    echo "Done! Restart your terminal for changes to take effect."
  else
    echo "Unsupported OS: $OSTYPE"
    return 1
  fi
}
