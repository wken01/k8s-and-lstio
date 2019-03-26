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
