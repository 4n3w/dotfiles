export GPG_TTY=$(tty)

alias k=kubectl
alias t=tanzu

alias gpra='git pull --rebase --autostash'
alias gs='git status'
alias gd='git diff'
alias gl='git log --all --decorate --graph --oneline'
alias vd='vimdiff'

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

use_github(){
  git config --global user.email '4n3w@users.noreply.github.com'
  git config --global user.name '4n3w'
  git config --global user.signingkey '68CDDFE4BB2A4007'
}

use_gitlab(){
  git config --global user.email 'anwood@vmware.com'
  git config --global user.name 'anwood'
  git config --global user.signingkey '2C7B2B98DF652673'
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

defunct_tkgslogin(){
    export KUBECTL_VSPHERE_PASSWORD='8V0=oZTZze3BksdwhDM'
    export CLUSTER_NAMESPACE=tap-learn
    kubectl vsphere login --server=https://vc01cl01-wcp.h2o-2-5037.h2o.vmware.com:6443 --vsphere-username administrator@vsphere.local --insecure-skip-tls-verify --tanzu-kubernetes-cluster-name view-2 --tanzu-kubernetes-cluster-namespace ${CLUSTER_NAMESPACE}
    kubectl vsphere login --server=https://vc01cl01-wcp.h2o-2-5037.h2o.vmware.com:6443 --vsphere-username administrator@vsphere.local --insecure-skip-tls-verify --tanzu-kubernetes-cluster-name build --tanzu-kubernetes-cluster-namespace ${CLUSTER_NAMESPACE}
    kubectl vsphere login --server=https://vc01cl01-wcp.h2o-2-5037.h2o.vmware.com:6443 --vsphere-username administrator@vsphere.local --insecure-skip-tls-verify --tanzu-kubernetes-cluster-name run --tanzu-kubernetes-cluster-namespace ${CLUSTER_NAMESPACE}
}

tkgslogin(){
    export KUBECTL_VSPHERE_PASSWORD='2qLPqOZrQZnmQHl0q$8'
    export KUBECTL_VSPHERE_USERNAME='administrator@vsphere.local'
    export CLUSTER_NAMESPACE=tap
    export H2O_SLOT="h2o-2-6585"
    H2O_KUBE_API="https://vc01cl01-wcp.$H2O_SLOT.h2o.vmware.com:6443"

    local clusters=(shared-services view build build2 build3 run)

    for cluster in ${clusters}; do
      kubectl vsphere login \
        --server=$H2O_KUBE_API \
        --vsphere-username $KUBECTL_VSPHERE_USERNAME \
        --insecure-skip-tls-verify \
        --tanzu-kubernetes-cluster-name $cluster \
        --tanzu-kubernetes-cluster-namespace ${CLUSTER_NAMESPACE}
    done
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
