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
