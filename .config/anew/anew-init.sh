export GPG_TTY=$(tty)

alias k=kubectl
alias t=tanzu

alias gpra='git pull --rebase --autostash'
alias gs='git status'
alias gd='git diff'
alias gl='git log --all --decorate --graph --oneline'
alias vd='vimdiff'

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

kick(){
    echo "y" | kctrl app kick -a $1 -n tap-install
}

kicktap(){
    kick tap
}

tap-apply(){
    tanzu apps workload apply -f config/workload.yaml --namespace dev --yes
} 

kicktapinstall(){
    kick tap-install
}

alias kickti=kicktapinstall

tap-install-values(){
    k get secrets tap-install-values  -oyaml -n tap-install -o jsonpath='{.data.tap-values\.yml}' | base64 -d
}

ktree(){
    k tree -n $1 workload $2
}

schema(){
    kubectl get pkgi -n tap-install | grep $1 | awk '{print $2"/"$3}' | xargs -I {} tanzu package available get {} --values-schema --namespace tap-install
}

events_in_namespace(){
    k get events --sort-by=".lastTimestamp" -n $1
}

kicknsp(){
    kick namespace-provisioner || true
    echo "y" | kctrl app kick -a provisioner -n tap-namespace-provisioning
}

retap(){
    tanzu package installed update tap -p tap.tanzu.vmware.com -v  --values-file tap-values.yaml -n tap-install && echo y | kicktap
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

uninstall_tap(){
 echo "y" | tanzu package installed delete tap -n tap-install
}

change_git_author(){
  git commit --amend --author="Author Name <email@address.com>" --no-edit
}


open_supply_chain(){
  imgpkg pull -b $(k get app ootb-supply-chain-testing-scanning -n tap-install -oyaml | yq e '.spec.fetch[0].imgpkgBundle.image') -o /tmp/bundle && code /tmp/bundle
# if you use the app name of ootb-templates you get all the common building blocks that are used in each of the OOTB supply chains.
  imgpkg pull -b $(k get app ootb-templates -n tap-install -oyaml | yq e '.spec.fetch[0].imgpkgBundle.image') -o /tmp/ootb-templates && code /tmp/ootb-templates
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
gettapvalues(){
    kubectl get secrets tap-install-values  -oyaml -n tap-install -o jsonpath='{.data.tap-values\.yml}' | base64 -d
}

mergeConfigs(){
    # https://support.tools/post/merge_kubeconfig_files
    cp ~/.kube/config ~/.kube/config_bk && KUBECONFIG=~/.kube/config:$1 kubectl config view --flatten > ~/.kube/config_tmp && mv ~/.kube/config_tmp ~/.kube/config
}
