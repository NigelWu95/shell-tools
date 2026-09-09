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
# 检查本机 TCP 端口是否处于监听状态
function is_local_port_listening() {
  local port=$1
  [[ $port =~ ^[0-9]+$ && $port -gt 0 && $port -lt 65536 ]] || return 1
  lsof -nP -a -iTCP:"$port" >/dev/null 2>&1
}

# 如果 xxx 端口是监听的就设置 http 代理
function set_http_proxy() {
  local port=$1
  if is_local_port_listening "$port"; then
    export http_proxy="http://127.0.0.1:$port"
    export https_proxy="http://127.0.0.1:$port"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$https_proxy"
  fi
}
# 如果 xxx 端口是监听的就设置 socks5 代理
function set_socks5_proxy() {
  local port=$1
  if is_local_port_listening "$port"; then
    export socks_proxy="socks5://127.0.0.1:$port"
    export all_proxy="$socks_proxy"
    export SOCKS_PROXY="$socks_proxy"
    export ALL_PROXY="$socks_proxy"
  fi
}
#设置网络检查url
network_check_url=https://google.com
function set_network_check_url() {
    network_check_url=$NETWORK_CHECK_URL
    if [[ -z $network_check_url ]]; then
        network_check_url=https://google.com
    fi
}
# 通过 curl 检测网络访问是否成功
function check_proxy_valid() {
    local curl_result curl_status http_code remote_ip total_time
    echo "[proxy] testing: ${network_check_url}"
    echo "[proxy] http=${http_proxy:-disabled} socks=${socks_proxy:-disabled}"

    if [[ -z "$http_proxy" && -z "$socks_proxy" ]]; then
        echo "[proxy] skipped: no local proxy endpoint is listening"
        return 1
    fi

    curl_result=$(curl --noproxy "" -L -sS -m 8 -o /dev/null \
        -w "%{http_code} %{remote_ip} %{time_total}" "$network_check_url")
    curl_status=$?
    read -r http_code remote_ip total_time <<< "$curl_result"

    if [[ $curl_status -eq 0 && "$http_code" =~ ^[23][0-9][0-9]$ ]]; then
        echo "[proxy] valid: HTTP $http_code, remote=$remote_ip, time=${total_time}s"
        return 0
    fi

    echo "[proxy] invalid: curl_exit=$curl_status, HTTP=${http_code:-000}, remote=${remote_ip:-unknown}"
    unset http_proxy https_proxy socks_proxy all_proxy
    unset HTTP_PROXY HTTPS_PROXY SOCKS_PROXY ALL_PROXY
    return 1
}
# 用一个 for 循环对多个端口（端口参数格式为 socks5_port1,http_port1 socks5_port2,http_port2）设置代理并检查，如果代理有效则退出，代理无效则继续设置下一个端口
function set_proxy_by_ordered_ports() {
    set_network_check_url
    echo "[proxy] automatic detection started"
    echo "[proxy] check URL: $network_check_url"
    # shellcheck disable=SC2068
    for port in $@; do
        socks5_port=$(echo $port | cut -d ',' -f 1)
        http_port=$(echo $port | cut -d ',' -f 2)
        unset http_proxy https_proxy socks_proxy all_proxy
        unset HTTP_PROXY HTTPS_PROXY SOCKS_PROXY ALL_PROXY
        echo "[proxy] candidate: SOCKS5 $socks5_port, HTTP $http_port"
        if is_local_port_listening "$socks5_port"; then
            echo "[proxy] SOCKS5 $socks5_port: detected"
        else
            echo "[proxy] SOCKS5 $socks5_port: unavailable"
        fi
        if is_local_port_listening "$http_port"; then
            echo "[proxy] HTTP $http_port: detected"
        else
            echo "[proxy] HTTP $http_port: unavailable"
        fi
        # 自动检测以实际 curl 结果为准，不因 lsof 看不到监听端口而提前跳过。
        # 这也兼容代理由其他网络命名空间、容器或特殊绑定方式提供的情况。
        if [[ $socks5_port =~ ^[0-9]+$ && $socks5_port -gt 0 && $socks5_port -lt 65536 ]]; then
            export socks_proxy="socks5://127.0.0.1:$socks5_port"
            export all_proxy="$socks_proxy"
            export SOCKS_PROXY="$socks_proxy"
            export ALL_PROXY="$socks_proxy"
        fi
        if [[ $http_port =~ ^[0-9]+$ && $http_port -gt 0 && $http_port -lt 65536 ]]; then
            export http_proxy="http://127.0.0.1:$http_port"
            export https_proxy="http://127.0.0.1:$http_port"
            export HTTP_PROXY="$http_proxy"
            export HTTPS_PROXY="$https_proxy"
        fi
        if check_proxy_valid; then
            echo "[proxy] selected: http=${http_proxy:-disabled}, socks=${socks_proxy:-disabled}"
            return 0
        fi
    done
    echo "[proxy] no working proxy candidate found; proxy disabled"
    return 1
}

# 手动切换代理：proxy xxnet / proxy off
function proxy() {
    case "$1" in
        xxnet)
            # 先清理自动检测或上一次手动设置留下的代理
            unset http_proxy https_proxy socks_proxy all_proxy
            unset HTTP_PROXY HTTPS_PROXY SOCKS_PROXY ALL_PROXY
            set_socks5_proxy 1080
            set_http_proxy 8086
            if [[ -n "$socks_proxy" && -n "$http_proxy" ]]; then
                echo "[proxy] xx-net endpoints configured"
                echo "[proxy] http/https: $http_proxy"
                echo "[proxy] socks/all:  $socks_proxy"
                if check_proxy_valid; then
                    echo "[proxy] xx-net proxy ready"
                else
                    echo "[proxy] xx-net ports are listening, but HTTP proxy validation failed"
                    return 1
                fi
            else
                unset http_proxy https_proxy socks_proxy all_proxy
                unset HTTP_PROXY HTTPS_PROXY SOCKS_PROXY ALL_PROXY
                echo "[proxy] xx-net unavailable: ports 1080/8086 are not both listening"
                return 1
            fi
            ;;
        off|none|disable)
            unset http_proxy https_proxy socks_proxy all_proxy
            unset HTTP_PROXY HTTPS_PROXY SOCKS_PROXY ALL_PROXY
            echo "proxy disabled"
            ;;
        *)
            echo "Usage: proxy {xxnet|off}"
            return 2
            ;;
    esac
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
