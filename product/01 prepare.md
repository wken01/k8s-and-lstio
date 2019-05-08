# 离线安装包准备


```

 #在本地能上网的虚拟机上安装 

 yum install -y yum-utils
 yum install -y createrepo
 yum install -y yum-plugin-downloadonly
 
 [root@localhost network]#  yumdownloader
 Loaded plugins: fastestmirror
 Usage: "yumdownloader [options] package1 [package2] 


 #在离线机上分别操作
 
 mkdir /home/soft
 mkdir /home/rpm/{dev,base,network,yum} -p
 

```


# 工具命令

```

 #搜索并卸载
 rpm -qa | grep wget
 yum remove wget
 
 #本地安装
 yum localinstall *.rpm -y
 rpm -ivp *.rpm 
 
 #下载组
 yumdownloader "@Development Tools" --resolve --destdir /data/yum-pkgs/dev-tools/ --下载软件组
 yumdownloader --resolve --destdir=/root/mypackages/ httpd  --单个包下载
 
 
```
