#!/bin/bash

#系统
#查看系统用户所有限制值
#ulimit -a
softdel()
{
  mv $@ ~/.trash/
}
truedel()
{
  /bin/rm -i $@
}
crontablist()
{
  cat /etc/passwd | cut -f 1 -d : | xargs -I {} crontab -l -u {}
}

#网络
#查看网络连接数
netconns()
{
  netstat -an | grep $1 | wc -l
}
#查看 TCP 的并发请求数
tcpconns()
{
  netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
#  netstat -n | grep  ^tcp|awk '{print $NF}' | sort -nr | uniq -c
#  netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,"t",state[key]}'
}

#进程
#查看进程打开文件数
pidfiles()
{
  lsof -p $1 | wc -l
}
#查看进程资源限制
pidlimits()
{
  cat /proc/$1/limits
}
#查看程序的线程数
procthreads()
{
  ps -efL | grep $1 | wc -l
}
#查看进程 CPU/MEM 占用率
proccpu()
{
  ps H -eo user,pid,ppid,tid,time,%cpu,cmd --sort=%cpu
}
procmem()
{
  ps H -eo user,pid,ppid,tid,time,%mem,cmd --sort=%mem
}

#磁盘
#获取磁盘列表
disks()
{
  fdisk -l | grep 'Disk' | grep '/dev' | awk '{print $2}' | awk -F: '{print $1}'| egrep 'xvd|vd|sd'
}

#文件
#匹配带日期的文件名
datefiles()
{
  ls $@ | grep -E "[1-9][[:digit:]]{3}(-|/)?(0[1-9]|1[0-2])(-|/)?([0-2][0-9]|3[0-1])"
}
#找出带日期的 .log 日志文件
findlogs()
{
  find $@ -regextype posix-egrep -regex ".*(\.log\.)?[1-9][[:digit:]]{3}(-|/)?(0[1-9]|1[0-2])(-|/)?([0-2][0-9]|3[0-1])(\.[[:digit:]]*)?(\.log)??"
}
#根据文件名过滤非本月的日志（即本月以前的日志）
findpremlogs()
{
  export ldate1=`date "+%Y-%m"` && export ldate2=`date "+%Y%m"` && export ldate3=`date "+%Y/%m"` && find $@ -regextype posix-egrep -regex ".*(\.log\.)?[1-9][[:digit:]]{3}(-|/)?(0[1-9]|1[0-2])(-|/)?([0-2][0-9]|3[0-1])(\.[[:digit:]]*)?(\.log)?" | grep -v -e $ldate1 -e $ldate2 -e $ldate3
}
#根据文件名过滤非本月的日志并查看文件大小
lhpremlogs()
{
   findpremlogs | xargs -r ls -lh -v
}
#根据文件名清理（永久删除）上个月及以前的日志（不需要 awk 判断日期大小）
rmpremlogs()
{
   findpremlogs | xargs -r rm -v
}
#根据目录名查找上个月及以前的日志目录
findpremlogds()
{
  export ldate1=`date "+%Y-%m"` && export ldate2=`date "+%Y%m"` && export ldate3=`date "+%Y/%m"` && export lyear=`date "+%Y$"` && find $@ -type d -regextype posix-egrep -regex ".*[1-9][[:digit:]]{3}(-|/)?(0[1-9]|1[0-2])?" | grep -v -e $ldate1 -e $ldate2 -e $ldate3 -e $lyear | xargs -r rm -r -v
}
#根据目录名清理（永久删除）上个月及以前的日志目录
rmpremlogds()
{
  findpremlogds | xargs -r rm -r -v
}
#一步清除（rm）上个月及以前的的日志文件与目录（如 nginx 日志目录）
rmpremlogsds()
{
  export ldate1=`date "+%Y-%m"` && export ldate2=`date "+%Y%m"` && export ldate3=`date "+%Y/%m"` && export lyear=`date "+%Y$"` && find $@ -regextype posix-egrep -regex ".*(\.log\.)?[1-9][[:digit:]]{3}(-|/)?(0[1-9]|1[0-2])?(-|/)?([0-2][0-9]|3[0-1])?(\.[[:digit:]]*)?(\.log)?" | grep -v -e $ldate1 -e $ldate2 -e $ldate3 -e $lyear | xargs -r rm -r -v
}
#查找修改日期x天以前的文件/目录（纯 find 命令）
findoutdaymfiles()
{
  find $1 -maxdepth $2 -mtime +$3 -type $4 -exec ls -l {} \;
}
#修改日期x天以前的文件/目录执行删除（纯 find 命令）
rmoutdaymfiles()
{
  find $1 -maxdepth $2 -mtime +$3 -type $4 -exec rm -rf {} \;
}

#kubectl
k8execbashforpod()
{
  kubectl exec -it $1 -- /bin/bash
}
applyffork8s()
{
  kubectl apply -f $@
}

#docker
dkerpull()
{
  docker pull $1
}
dkerpush()
{
  docker push $1
}
dkerrunbash()
{
  docker run -it $1 /bin/bash
}
dkerexecbash()
{
  docker exec -it $1 /bin/bash
}
dockerrms()
{
  docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v
}
dkerirms()
{
  docker images | grep '^<none>' | awk '{print $3}' | xargs -r docker image rm -v
}
dkerrm()
{
  docker rm $@
}
dkerirm()
{
  docker image rm $@
}

#git
gicheckout(){
  git checkout $1
}
giclone()
{
  git clone $1
}
gicommit()
{
  git commit -m $1
}
gimerge()
{
  git merge $1
}
gipsh()
{
  git push $1
}
gipshoset()
{
  git push origin $1 --set-upstream
}
gipll()
{
  git pull $1
}
gibcrt()
{
  git checkout -b $1
}
gibdel()
{
  git checkout -b $1
}
gibrdel()
{
  git push origin $1 --delete
}
