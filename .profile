#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/wubingheng/.sdkman"
[[ -s "/Users/wubingheng/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wubingheng/.sdkman/bin/sdkman-init.sh"

# [[ -s "~/.autojump/etc/profile.d/autojump.sh" ]] && source "~/.autojump/etc/profile.d/autojump.sh"

# export JAVA_HOME=/Users/wubingheng/.sdkman/candidates/java/current
# export JRE_HOME=$JAVA_HOME/jre
# export CLASS_PATH='$JAVA_HOME/lib/dt.jar;$JAVA_HOME/lib/tools.jar;$JRE_HOME/lib'

export GOROOT=/usr/local/opt/go/libexec
export GOPATH=/Users/wubingheng/go
export PATH=$PATH:/Users/wubingheng/.shell-tools:/Users/wubingheng/Public/Tools:$GOROOT/bin:$GOPATH/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

source aliased.sh
alias rm=softdel
alias trm=truedel

alias sublime='open -a /Applications/Sublime\ Text.app/'
alias vscode='open -a /Applications/Visual\ Studio\ Code.app/'

alias ssh-83='ssh -i ~/.ssh/id_rsa_new ubuntu@106.54.255.83'

alias chk8sclusterpre='ln -snf ~/.kube/pre.config ~/.kube/config'
alias chk8sclusterprod-fin='ln -snf ~/.kube/prod.config ~/.kube/config'
alias prek8spods='ln -snf ~/.kube/pre.config ~/.kube/config && kubectl get pods'
alias prodk8spods='ln -snf ~/.kube/prod.config ~/.kube/config && kubectl get pods'
alias k8applyfforpre='ln -snf ~/.kube/pre.config ~/.kube/config && applyffork8s'
alias k8applyfforprod='ln -snf ~/.kube/prod.config ~/.kube/config && applyffork8s'