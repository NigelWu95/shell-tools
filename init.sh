#!/bin/bash

simplified_shell="simplified.sh"
regis_shell="pregister.sh"
current_path=`pwd`
opsfiles_path=`find $current_path -name "shell-tools" | xargs -r echo`

if [ -d $HOME/.shell-tools ]; then
  if [ -f $HOME/.shell-tools/simplified.sh ]; then
    simplified_shell="shell-tools-simplified.sh"
  fi
  if [ -f $HOME/.shell-tools/pregister.sh ]; then
    regis_shell="shell-tools-pregister.sh"
  fi
  ls $opsfiles_path | xargs -I'{}' cp $opsfiles_path/{} $HOME/.shell-tools/"shell-tools-"{}
else
  mkdir $HOME/.shell-tools/
  ls $opsfiles_path | xargs -I'{}' cp $opsfiles_path/{} $HOME/.shell-tools/
fi

simplified_source_exists=`grep "$simplified_shell" ~/.bashrc | awk '{ print $1 }'`
regis_source_exists=`grep "$regis_shell" ~/.bashrc | awk '{ print $1 }'`
if [ "x"$simplified_source_exists = "x" ]; then
  echo -e "source $HOME/.shell-tools/$simplified_shell" >> ~/.bashrc
fi
if [ "x"$regis_source_exists = "x" ]; then
  echo -e "source $HOME/.shell-tools/$regis_shell" >> ~/.bashrc
fi
source ~/.bashrc
