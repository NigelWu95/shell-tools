#!/bin/bash

regis_sdkman()
{
  curl -s "https://get.sdkman.io" | bash
}

regis_golang()
{
  echo -e "export GOROOT=/usr/local/opt/go/libexec\nexport GOPATH=$HOME/go" >> ~/.profile
  sed -i.bak "s/export PATH=/export PATH=\$GOROOT\/bin:\$GOPATH\/bin:/g" ~/.profile
  source ~/.profile
}

regis_jclapath()
{
  echo -e "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> ~/.profile
  source ~/.profile
}

regis_path()
{
  add_path=$@
  add_path=${add_path//\//\\\/}
  sed -i.bak "s/export PATH=/export PATH=$add_path:/g" ~/.profile
  source ~/.profile
}

regis_command()
{
  app_path=${2/ /\\ /}
  chmod +x $app_path
  add_app="alias $1='sh $app_path'"
  echo $add_app >> ~/.profile
  source ~/.profile
}

regis_ssh()
{
  if [[ $# == 2 ]]; then
    echo "OK"
    add_ssh="alias $1='ssh $2'"
  elif [[ $# == 3 ]]; then
    rsa_path=${2/ /\\ /}
    add_ssh="alias $1='ssh -i $rsa_path $3'"
  fi
  echo $add_ssh >> ~/.profile
  source ~/.profile
}

regis_app()
{
  app_path=${2/ /\\ /}
  add_app="alias $1='open -a $app_path'"
  echo $add_app >> ~/.profile
  source ~/.profile
}

regis_locale_utf8()
{
  echo "export LC_ALL=en_US.UTF-8" >> ~/.profile
  source ~/.profile
}

regis_project()
{
  add_project="alias $1='idea ${2/ /\\ /}'"
  echo $add_project >> ~/.profile
  source ~/.profile
}
