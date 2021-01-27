#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/wubingheng/.sdkman"
[[ -s "/Users/wubingheng/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wubingheng/.sdkman/bin/sdkman-init.sh"

# [[ -s "~/.autojump/etc/profile.d/autojump.sh" ]] && source "~/.autojump/etc/profile.d/autojump.sh"

# export JAVA_HOME=/Users/wubingheng/.sdkman/candidates/java/current
# export JRE_HOME=$JAVA_HOME/jre
# export CLASSPATH=$JAVA_HOME/lib/dt.jar;$JAVA_HOME/lib/tools.jar;$JRE_HOME/lib

export GOROOT=/usr/local/opt/go/libexec
export GOPATH=~/go
export PATH=$PATH:~/.shell-tools:~/Public/Tools:$GOROOT/bin:$GOPATH/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

source pregister.sh
source shvared.sh
source simplified.sh
alias rm=softdel
alias trm=truedel

alias sublime='open -a /Applications/Sublime\ Text.app/'
alias vscode='open -a /Applications/Visual\ Studio\ Code.app/'

export LC_ALL=en_US.UTF-8
