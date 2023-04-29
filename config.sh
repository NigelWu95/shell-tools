#!/bin/bash

#sshconfig
# TODO

#gitconfig
# TODO

#gnuconfig
# TODO

#dockerconfig
# TODO

#kubeconfig
# TODO

#qsuitsconfig
# TODO

#mvnconfig
# TODO

#sdkmanconfig
# TODO

#proxy_config
# 如果 xxx 端口是监听的就设置 http 代理
function set_http_proxy() {
  port=$1
  if [[ $port =~ ^[0-9]+$ && $port -gt 0 && $port -lt 65536 ]]; then
    #if lsof -i:1087 | grep LISTEN > /dev/null; then
    if [[ $(echo "" | telnet 127.0.0.1 $port | xargs echo -n | sed "s/ //g" | grep -E "Connected|Escape") ]]; then
        export http_proxy=http://127.0.0.1:$port
        export https_proxy=http://127.0.0.1:$port
    fi
  fi
}
# 如果 xxx 端口是监听的就设置 socks5 代理
function set_socks5_proxy() {
    port=$1
    if [[ $port =~ ^[0-9]+$ && $port -gt 0 && $port -lt 65536 ]]; then
      #if lsof -i:1087 | grep LISTEN > /dev/null; then
      if [[ $(echo "" | telnet 127.0.0.1 $port | xargs echo -n | sed "s/ //g" | grep -E "Connected|Escape") ]]; then
          export socks_proxy=socks5://127.0.0.1:$port
      fi
    fi
}
# 通过 curl 检查访问 google.com 是否成功
function check_proxy_valid() {
    if [[ $(curl -L -s -m 5 -o /dev/null -w "%{http_code}" https://twitter.com) == 200 ]]; then
        echo "proxy is valid: "$socks_proxy
        return 0
    else
        echo "proxy is invalid"
        unset http_proxy
        unset https_proxy
        unset socks_proxy
        return 1
    fi
}
# 用一个 for 循环对多个端口（端口参数格式为 socks5_port1,http_port1 socks5_port2,http_port2）设置代理并检查，如果代理有效则退出，代理无效则继续设置下一个端口
function set_proxy_by_ordered_ports() {
    # shellcheck disable=SC2068
    for port in $@; do
        socks5_port=$(echo $port | cut -d ',' -f 1)
        http_port=$(echo $port | cut -d ',' -f 2)
        set_socks5_proxy $socks5_port
        set_http_proxy $http_port
        check_proxy_valid
        if [[ $? == 0 ]]; then
            break
        fi
    done
}

# python 的设置
function set_python() {
    #检查是否存在 python2，如果没有则将 python 命令转到 python3
    if ! command -v python &> /dev/null; then
        if command -v python2 &> /dev/null; then
            alias python=python2
        else
            alias python=python3
        fi
    fi
    if ! command -v pip &> /dev/null; then
        if command -v pip2 &> /dev/null; then
            alias pip=pip2
        else
            alias pip=pip3
        fi
    fi
#    if [[ -n $http_proxy ]]; then
#        pip config set global.proxy $http_proxy
#    fi
#    if [[ -n $https_proxy ]]; then
#        pip config set global.proxy $https_proxy
#    fi
#    if [[ -n $socks_proxy ]]; then
#        pip config set global.proxy $socks_proxy
#    fi
}
