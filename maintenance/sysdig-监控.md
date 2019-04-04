# 安装

```
服务器被黑后，一直有进程占用大量cpu，top命令无法显示找出相关进程。怀疑系统命令被替换，随后用sysdig排查问题。

sysdig    https://support.sysdig.com

安装：

rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public
curl -s -o /etc/yum.repos.d/draios.repo http://download.draios.com/stable/rpm/draios.repo
yum list dkms
rpm -i http://mirror.us.leaseweb.net/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install kernel-devel-$(uname -r) #可能安装失败，直接安装相似的软件 yum list kernel-devel-*
yum -y install sysdig
报错提示解决error opening device /dev/sysdig0. Make sure you have root credentials and that the sysdig-probe module is loaded.
sysdig-probe-loader

```


# 简单使用参考

```
 使用：

简单集成界面

csysdig

 #查看进程占用cpu 情况
sysdig -c topprocs_cpu    

#查看占用网络带宽最多的进程

sysdig -c topprocs_net

#查看使用硬盘带宽最多的进程：

sysdig -c topprocs_file
```

# 使用参考

```
  https://yq.aliyun.com/ziliao/65685
  https://github.com/draios/sysdig
```


#使用全集

```

This is an ever growing list of cool things you can do with sysdig commands.
Got another interesting idea? Anything that you would find useful and that isn't here? Feel free to add to this list, or send a message to the sysdig mailing list to discuss!

Note: Make sure you also take a look at csysdig, which packs a lot of useful functionality into a simple to use UI.
Note: The command lines on this page return live data. However, you can use them with trace files too by just adding the -r switch.
Note: If you need a list of basic sysdig commands, for instance to learn how to create a trace file, see the quick reference guide

Networking
Containers
Application
Disk I/O
Processes and CPU usage
Performance and Errors
Security
Tracing

Networking
See the top processes in terms of network bandwidth usage

  sysdig -c topprocs_net
Show the network data exchanged with the host 192.168.0.1

As binary:

  sysdig -s2000 -X -c echo_fds fd.cip=192.168.0.1  
As ASCII:

  sysdig -s2000 -A -c echo_fds fd.cip=192.168.0.1
See the top local server ports

In terms of established connections:

  sysdig -c fdcount_by fd.sport "evt.type=accept"  
In terms of total bytes:

  sysdig -c fdbytes_by fd.sport
See the top client IPs

In terms of established connections

  sysdig -c fdcount_by fd.cip "evt.type=accept"  
In terms of total bytes

  sysdig -c fdbytes_by fd.cip
List all the incoming connections that are not served by apache.

  sysdig -p"%proc.name %fd.name" "evt.type=accept and proc.name!=httpd"

Containers
View the list of containers running on the machine and their resource usage

  sudo csysdig -vcontainers
View the list of processes with container context

  sudo csysdig -pc
View the CPU usage of the processes running inside the wordpress1 container

  sudo sysdig -pc -c topprocs_cpu container.name=wordpress1
View the network bandwidth usage of the processes running inside the wordpress1 container

  sudo sysdig -pc -c topprocs_net container.name=wordpress1
View the processes using most network bandwidth inside the wordpress1 container

  sudo sysdig -pc -c topprocs_net container.name=wordpress1
View the top files in terms of I/O bytes inside the wordpress1 container

  sudo sysdig -pc -c topfiles_bytes container.name=wordpress1
View the top network connections inside the wordpress1 container

  sudo sysdig -pc -c topconns container.name=wordpress1
Show all the interactive commands executed inside the wordpress1 container

  sudo sysdig -pc -c spy_users container.name=wordpress1

Application
See all the GET HTTP requests made by the machine

  sudo sysdig -s 2000 -A -c echo_fds fd.port=80 and evt.buffer contains GET
See all the SQL select queries made by the machine

  sudo sysdig -s 2000 -A -c echo_fds evt.buffer contains SELECT 
See queries made via apache to an external MySQL server happening in real time

  sysdig -s 2000 -A -c echo_fds fd.sip=192.168.30.5 and proc.name=apache2 and evt.buffer contains SELECT

Disk I/O
See the top processes in terms of disk bandwidth usage

  sysdig -c topprocs_file
List the processes that are using a high number of files

  sysdig -c fdcount_by proc.name "fd.type=file"
See the top files in terms of read+write bytes

  sysdig -c topfiles_bytes
Print the top files that apache has been reading from or writing to

  sysdig -c topfiles_bytes proc.name=httpd
Basic opensnoop: snoop file opens as they occur

  sysdig -p "%12user.name %6proc.pid %12proc.name %3fd.num %fd.typechar %fd.name" evt.type=open
See the top directories in terms of R+W disk activity

  sysdig -c fdbytes_by fd.directory "fd.type=file"
See the top files in terms of R+W disk activity in the /tmp directory

  sysdig -c fdbytes_by fd.filename "fd.directory=/tmp/"
Observe the I/O activity on all the files named 'passwd'

  sysdig -A -c echo_fds "fd.filename=passwd"
Display I/O activity by FD type

  sysdig -c fdbytes_by fd.type

Processes and CPU usage
See the top processes in terms of CPU usage

  sysdig -c topprocs_cpu
Observe the standard output of a process

  sysdig -s4096 -A -c stdout proc.name=cat

Performance and Errors
See the files where most time has been spent

  sysdig -c topfiles_time
See the files where apache spent most time

  sysdig -c topfiles_time proc.name=httpd
See the top processes in terms of I/O errors

  sysdig -c topprocs_errors
See the top files in terms of I/O errors

  sysdig -c topfiles_errors
See all the failed disk I/O calls

  sysdig fd.type=file and evt.failed=true
See all the failed file opens by httpd

  sysdig "proc.name=httpd and evt.type=open and evt.failed=true"
See the system calls where most time has been spent

  sysdig -c topscalls_time
See the top system calls returning errors

  sysdig -c topscalls "evt.failed=true"
snoop failed file opens as they occur

  sysdig -p "%12user.name %6proc.pid %12proc.name %3fd.num %fd.typechar %fd.name" evt.type=open and evt.failed=true
Print the file I/O calls that have a latency greater than 1ms:

  sysdig -c fileslower 1

Security
Show the directories that the user "root" visits

  sysdig -p"%evt.arg.path" "evt.type=chdir and user.name=root"
Observe ssh activity

  sysdig -A -c echo_fds fd.name=/dev/ptmx and proc.name=sshd
Show every file open that happens in /etc

  sysdig evt.type=open and fd.name contains /etc
Show the ID of all the login shells that have launched the "tar" command

  sysdig -r file.scap -c list_login_shells tar
Show all the commands executed by the login shell with the given ID

  sysdig -r trace.scap.gz -c spy_users proc.loginshellid=5459
Applied use of sysdig for forensics analysis:

Fishing for Hackers: Analysis of a Linux Server Attack
Fishing for Hackers (Part 2): Quickly Identify Suspicious Activity With Sysdig

Tracing
Create a trace to measure website latency:

  echo ">::website-latency::" > /dev/null

  curl -s http://sysdig.org > /dev/null	

  echo "<::website-latency::" > /dev/null
Measure a span defined by a login attempt, identified by the thread:

  echo ">:t:login:username=loris:" > /dev/null

  echo "<:t:login::" > /dev/null
```


# 使用2

```
 
```
