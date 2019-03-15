# 部署Node节点

``` 
  kubernetes work 节点运行如下组件： docker kubelet kube-proxy flannel
```

##  1.Docker环境安装

在节点 192.168.3.4和192.168.3.6 上执行

``` bash
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum list docker-ce --showduplicates | sort -r
  yum list installed | grep docker
  yum -y remove docker <docker-name>
  yum install docker-ce -y
  systemctl start docker && systemctl enable docker
```

##  2.部署kubelet组件

在节点 192.168.3.4和192.168.3.6 上执行

```
  kublet 运行在每个 worker 节点上，接收 kube-apiserver 发送的请求，管理 Pod 容器，执行交互式命令，如exec、run、logs 等; kublet 启动时自动向 kube-apiserver 注册节点信息，内置的 cadvisor 统计和监控节点的资源使用情况; 为确保安全，只开启接收 https 请求的安全端口，对请求进行认证和授权，拒绝未授权的访问(如apiserver、heapster)
  
```

### 2.1安装二进制文件

在节点 192.168.3.4和192.168.3.6 上执行

``` bash
  wget https://dl.k8s.io/v1.13.1/kubernetes-node-linux-amd64.tar.gz
  tar zxvf kubernetes-node-linux-amd64.tar.gz
  cd kubernetes/node/bin/
  cp kube-proxy kubelet kubectl /k8s/kubernetes/bin/
```

### 2.2复制相关证书到node节点
 
``` bash
  scp *.pem 192.168.3.6:$PWD   
```

### 2.3创建kubelet bootstrap kubeconfig文件 通过脚本实现

token.csv，environment.sh 必须在master上创建，执行完拷贝bootstrap.kubeconfig,kube-proxy.kubeconfig,token.csv 到个节点相同目录
,
``` bash
  vim /k8s/kubernetes/cfg/environment.sh
  #!/bin/bash
  #创建kubelet bootstrapping kubeconfig 
  BOOTSTRAP_TOKEN=f2c50331f07be89278acdaf341ff1ecc
  KUBE_APISERVER="https://192.168.3.3:6443"
  #设置集群参数
  kubectl config set-cluster kubernetes \
    --certificate-authority=/k8s/kubernetes/ssl/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=bootstrap.kubeconfig

  #设置客户端认证参数
  kubectl config set-credentials kubelet-bootstrap \
    --token=${BOOTSTRAP_TOKEN} \
    --kubeconfig=bootstrap.kubeconfig

  # 设置上下文参数
  kubectl config set-context default \
    --cluster=kubernetes \
    --user=kubelet-bootstrap \
    --kubeconfig=bootstrap.kubeconfig

  # 设置默认上下文
  kubectl config use-context default --kubeconfig=bootstrap.kubeconfig

  #----------------------

  # 创建kube-proxy kubeconfig文件

  kubectl config set-cluster kubernetes \
    --certificate-authority=/k8s/kubernetes/ssl/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials kube-proxy \
    --client-certificate=/k8s/kubernetes/ssl/kube-proxy.pem \
    --client-key=/k8s/kubernetes/ssl/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes \
    --user=kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
```

### 2.4执行脚本

``` bash
  [root@elasticsearch02 cfg]# sh environment.sh 
  Cluster "kubernetes" set.
  User "kubelet-bootstrap" set.
  Context "default" created.
  Switched to context "default".
  Cluster "kubernetes" set.
  User "kube-proxy" set.
  Context "default" created.
  Switched to context "default".
  [root@elasticsearch02 cfg]# ls
  bootstrap.kubeconfig  environment.sh  kube-proxy.kubeconfig
  
```

### 2.5创建kubelet参数配置模板文件

在节点上创建

``` bash
  vim /k8s/kubernetes/cfg/kubelet.config
  kind: KubeletConfiguration
  apiVersion: kubelet.config.k8s.io/v1beta1
  address: 192.168.3.4
  port: 10250
  readOnlyPort: 10255
  cgroupDriver: cgroupfs
  clusterDNS: ["10.254.0.10"]
  clusterDomain: cluster.local.
  failSwapOn: false
  authentication:
    anonymous:
      enabled: true

```

### 2.6创建kubelet配置文件

``` bash
  vim /k8s/kubernetes/cfg/kubelet.conf

  KUBELET_OPTS="--logtostderr=true \
  --v=4 \
  --hostname-override=192.168.3.4 \
  --kubeconfig=/k8s/kubernetes/cfg/kubelet.kubeconfig \
  --bootstrap-kubeconfig=/k8s/kubernetes/cfg/bootstrap.kubeconfig \
  --config=/k8s/kubernetes/cfg/kubelet.config \
  --cert-dir=/k8s/kubernetes/ssl \
  --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0"
```

### 2.7创建kubelet systemd文件
``` bash
  vim /usr/lib/systemd/system/kubelet.service 

  [Unit]
  Description=Kubernetes Kubelet
  After=docker.service
  Requires=docker.service

  [Service]
  EnvironmentFile=/k8s/kubernetes/cfg/kubelet.conf
  ExecStart=/k8s/kubernetes/bin/kubelet $KUBELET_OPTS
  Restart=on-failure
  KillMode=process

  [Install]
  WantedBy=multi-user.target
```

### 2.8将kubelet-bootstrap用户绑定到系统集群角色

``` bash
  kubectl create clusterrolebinding kubelet-bootstrap \
    --clusterrole=system:node-bootstrapper \
    --user=kubelet-bootstrap
```

### 2.9启动kubelet服务

``` bash
  systemctl daemon-reload 
  systemctl enable kubelet 
  systemctl start kubelet
```


### 2.10Master接受kubelet CSR请求 可以手动或自动 approve CSR 请求。推荐使用自动的方式，因为从 v1.8 版本开始，可以自动轮转approve csr 后生成的证书，如下是手动 approve CSR请求操作方法 查看CSR列表

``` bash
  kubectl get csr
  NAME                                                   AGE    REQUESTOR           CONDITION
  node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc   102s   kubelet-bootstrap   Pending
```

### 2.11接受node
 
 ``` bash
 
 kubectl certificate approve node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc
  certificatesigningrequest.certificates.k8s.io/node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc approved

 ```
 
 ### 2.12再查看csr
 
  ``` bash
  kubectl get csr
  NAME                                                   AGE     REQUESTOR           CONDITION
  node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc   5m13s   kubelet-bootstrap   Approved,Issued
 ```
 
 ## 3.部署kube-proxy组件
 
 kube-proxy 运行在所有 node节点上，它监听 apiserver 中 service 和 Endpoint 的变化情况，
 创建路由规则来进行服务负载均衡 1）创建 kube-proxy 配置文件
 
 ``` bash
   vim /k8s/kubernetes/cfg/kube-proxy.conf
   KUBE_PROXY_OPTS="--logtostderr=true \
  --v=4 \
  --hostname-override=192.168.3.4 \
  --cluster-cidr=10.254.0.0/16 \
  --kubeconfig=/k8s/kubernetes/cfg/kube-proxy.kubeconfig"
 
 ```

### 3.1创建kube-proxy systemd文件
vim /usr/lib/systemd/system/kube-proxy.service 
``` bash
  [Unit]
  Description=Kubernetes Proxy
  After=network.target

  [Service]
  EnvironmentFile=-/k8s/kubernetes/cfg/kube-proxy.conf
  ExecStart=/k8s/kubernetes/bin/kube-proxy $KUBE_PROXY_OPTS
  Restart=on-failure

  [Install]
  WantedBy=multi-user.target
```

### 3.2启动kube-proxy服务
``` bash
  systemctl daemon-reload 
  systemctl enable kube-proxy 
  systemctl start kube-proxy
  systemctl status kube-proxy
```

### 查看集群状态
``` bash
 kubectl get nodes
 
 NAME        STATUS   ROLES    AGE     VERSION
192.168.3.4   Ready    <none>   9m15s   v1.13.0
192.168.3.6   Ready    <none>   9m15s   v1.13.0
 
 ```

## 4.部署flanneld网络组件

```
  默认没有flanneld网络，Node节点间的pod不能通信，只能Node内通信，为了部署步骤简洁明了，故flanneld放在后面安装 flannel服务需要先于docker启动。       flannel服务启动时主要做了以下几步的工作： 从etcd中获取network的配置信息 划分subnet，
  并在etcd中进行注册 将子网信息记录到/run/flannel/subnet.env中
```

### 4.1 etcd注册网段

``` bash
    /k8s/etcd/bin/etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints="https://192.168.3.3:2379,https://192.168.3.4:2379,https://192.168.3.6:2379"  set /k8s/network/config  '{ "Network": "10.254.0.0/16", "Backend": {"Type": "vxlan"}}'
  { "Network": "10.254.0.0/16", "Backend": {"Type": "vxlan"}}
```
flanneld 当前版本 (v0.10.0) 不支持 etcd v3，故使用 etcd v2 API 写入配置 key 和网段数据； 写入的 Pod 网段 ${CLUSTER_CIDR} 必须是 /16 段地址，必须与 kube-controller-manager 的 –cluster-cidr 参数值一致；

### 4.2flannel安装,解压安装

``` bash
  tar -xvf flannel-v0.10.0-linux-amd64.tar.gz
  mv flanneld mk-docker-opts.sh /k8s/kubernetes/bin/
```

### 4.3 配置flanneld
``` bash
  vim /k8s/kubernetes/cfg/flanneld.conf
  
  FLANNEL_OPTIONS="--etcd-endpoints=https://192.168.3.3:2379,https://192.168.3.4:2379,https://192.168.3.6:2379 -etcd-cafile=/k8s/etcd/ssl/ca.pem -etcd-certfile=/k8s/etcd/ssl/server.pem -etcd-keyfile=/k8s/etcd/ssl/server-key.pem -etcd-prefix=/k8s/network"
  
  vim /usr/lib/systemd/system/flanneld.service
  
  [Unit]
  Description=Flanneld overlay address etcd agent
  After=network-online.target network.target
  Before=docker.service

  [Service]
  Type=notify
  EnvironmentFile=/k8s/kubernetes/cfg/flanneld.conf
  ExecStart=/k8s/kubernetes/bin/flanneld --ip-masq $FLANNEL_OPTIONS
  ExecStartPost=/k8s/kubernetes/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/subnet.env
  Restart=on-failure

  [Install]
  WantedBy=multi-user.target
  
  vim /usr/lib/systemd/system/docker.service
  [Unit]
  Description=Docker Application Container Engine
  Documentation=https://docs.docker.com
  After=network-online.target firewalld.service
  Wants=network-online.target

  [Service]
  Type=notify
  EnvironmentFile=/run/flannel/subnet.env
  ExecStart=/usr/bin/dockerd $DOCKER_NETWORK_OPTIONS
  ExecReload=/bin/kill -s HUP $MAINPID
  LimitNOFILE=infinity
  LimitNPROC=infinity
  LimitCORE=infinity
  TimeoutStartSec=0
  Delegate=yes
  KillMode=process
  Restart=on-failure
  StartLimitBurst=3
  StartLimitInterval=60s

  [Install]
  WantedBy=multi-user.target
```

``` 注意
  mk-docker-opts.sh 脚本将分配给 flanneld 的 Pod 子网网段信息写入 /run/flannel/docker 文件，
  后续 docker 启动时 使用这个文件中的环境变量配置 docker0 网桥； flanneld 使用系统缺省路由所在的接口与其它节点通信，
  对于有多个网络接口（如内网和公网）的节点，可以用 -iface 参数指定通信接口; flanneld 运行时需要 root 权限；
  
  配置Docker启动指定子网 修改EnvironmentFile=/run/flannel/subnet.env，ExecStart=/usr/bin/dockerd $DOCKER_NETWORK_OPTIONS即可
```

### 4.4 启动服务 注意启动flannel前要关闭docker及相关的kubelet这样flannel才会覆盖docker0网桥
``` bash
  systemctl daemon-reload
  systemctl stop docker
  systemctl start flanneld
  systemctl enable flanneld
  systemctl start docker
  systemctl restart kubelet
  systemctl restart kube-proxy
```

### 4.5 验证服务

``` bash
  [root@elasticsearch02 bin]# cat /run/flannel/subnet.env 
  DOCKER_OPT_BIP="--bip=10.254.35.1/24"
  DOCKER_OPT_IPMASQ="--ip-masq=false"
  DOCKER_OPT_MTU="--mtu=1450"
  DOCKER_NETWORK_OPTIONS=" --bip=10.254.35.1/24 --ip-masq=false --mtu=1450"
  
  ip a
  
  [root@elasticsearch02 bin]# ip a
  1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
      inet 127.0.0.1/8 scope host lo
         valid_lft forever preferred_lft forever
  2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
      link/ether 52:54:00:a4:ca:ff brd ff:ff:ff:ff:ff:ff
      inet 192.168.3.4/24 brd 10.2.8.255 scope global eth0
         valid_lft forever preferred_lft forever
  3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
      link/ether 02:42:06:0a:ab:32 brd ff:ff:ff:ff:ff:ff
      inet 10.254.35.1/24 brd 10.254.35.255 scope global docker0
         valid_lft forever preferred_lft forever
  4: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN 
      link/ether 72:59:dc:2b:0a:21 brd ff:ff:ff:ff:ff:ff
      inet 10.254.35.0/32 scope global flannel.1
         valid_lft forever preferred_lft forever
```
