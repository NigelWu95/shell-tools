#!/usr/bin/env bash

# 本命令用于显示指定路径或者当前路径的文件结构，支持搜索
# lls 显示当前目录的文件结构
# lls 接关键词  搜索当前目录
# lls 目录 关键词 搜索指定目录

# 本命令依赖于 tree 命令
DIR=
KEYWORD=

# 不传路径 默认为搜索
if [ $# -eq 1 ]; then
  KEYWORD=$1
fi

# 指定路径搜索
if [ $# -eq 2 ]; then
  DIR=$1
  KEYWORD=$2
fi

if [ -n "$DIR" ]; then
   cd "$DIR" || exit 1
fi

pwd
tree -C -f | grep "$KEYWORD"
