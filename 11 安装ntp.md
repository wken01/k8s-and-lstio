# 安装ntp 处理各节点时间同步问题

源于这样的系统日志错误
```

```
Apr 04 07:13:37 k8s-node-2 etcd[5667]: the clock difference against peer 8985c5debfc1e55c is too high [1m47.480274814s > 1s] (prober "ROUND_TRIPPER_SNAPSHOT")

```
  yum install -y ntp
  systemctl enable ntpd
  systemctl start ntpd
  timedatectl set-timezone Asia/Shanghai 


  vi /etc/ntp.conf
  

  restrict 192.168.1.150 mask 255.255.255.0 nomodify notrap #每隔节点上添加 192.168.1.150是master节点
  
  systemctl restart ntpd #在每个节点上操作
  
```

ntpstat

```
synchronised to NTP server (124.108.20.1) at stratum 3 
   time correct to within 1079 ms
   polling server every 64 s
```

systemctl status ntpd.service

```
  ● ntpd.service - Network Time Service
   Loaded: loaded (/usr/lib/systemd/system/ntpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2019-04-04 16:49:14 CST; 1min 40s ago
  Process: 23845 ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 23846 (ntpd)
    Tasks: 1
   Memory: 616.0K
   CGroup: /system.slice/ntpd.service
           └─23846 /usr/sbin/ntpd -u ntp:ntp -g
           
```
