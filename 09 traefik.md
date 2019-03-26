#  traefik简介

```
Træfɪk 是一个为了让部署微服务更加便捷而诞生的现代HTTP反向代理、负载均衡工具。 它支持多种后台 (Docker, Swarm, Kubernetes, Marathon, Mesos, Consul, Etcd, Zookeeper, BoltDB, Rest API, file…) 
来自动化、动态的应用它的配置文件设置。

```



# 特性

```

它非常快
无需安装其他依赖，通过Go语言编写的单一可执行文件
支持 Rest API
多种后台支持：Docker, Swarm, Kubernetes, Marathon, Mesos, Consul, Etcd, 并且还会更多
后台监控, 可以监听后台变化进而自动化应用新的配置文件设置
配置文件热更新。无需重启进程
正常结束http连接
后端断路器
轮询，rebalancer 负载均衡
Rest Metrics
支持最小化 官方 docker 镜像
后台支持SSL
前台支持SSL（包括SNI）
清爽的AngularJS前端页面
支持Websocket
支持HTTP/2
网络错误重试
支持Let’s Encrypt (自动更新HTTPS证书)
高可用集群模式

```
