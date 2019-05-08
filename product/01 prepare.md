# 离线安装包准备


```

 在本地能上网的虚拟机上安装 

 yum install -y yum-utils
 yum install -y createrepo
 yum install -y yum-plugin-downloadonly
 
 [root@localhost network]#  yumdownloader
 Loaded plugins: fastestmirror
 Usage: "yumdownloader [options] package1 [package2] 



 mkdir /home/soft
 mkdir /home/rpm/{dev,base,network,yum} -p
```
