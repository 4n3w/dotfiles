export GPG_TTY=$(tty)

alias k=kubectl
alias t=tanzu

alias gpra='git pull --rebase --autostash'
alias gs='git status'
alias gd='git diff'
alias gl='git log --all --decorate --graph --oneline'

kicktap(){
    kctrl app kick -a tap -n tap-install
}

ktree(){
    k tree -n $1 workload $2
}

events_in_namespace(){
    k get events --sort-by=".lastTimestamp" -n $1
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
