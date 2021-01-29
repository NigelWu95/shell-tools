# shell-tools
shell script 

#### 注册定时任务
######
每月 2 号 2 点钟清除 /home/admin/logs 下上个月的日志文件：  
`regis_crontab 0 2 2 * * rmpremlogsds /home/admin/logs`

每隔三天 2 点钟清除 workspace 下的一层目录文件：  
`regis_crontab "0 2 */3 * * rmoutdaymfiles workspace 1 3 d"`
