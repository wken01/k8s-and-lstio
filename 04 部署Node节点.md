# 部署Node节点

``` 
  kubernetes work 节点运行如下组件： docker kubelet kube-proxy flannel
```

##  (1)Docker环境安装

在节点 192.168.3.4和192.168.3.6 上执行

``` bash
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum list docker-ce --showduplicates | sort -r
  yum list installed | grep docker
  yum -y remove docker <docker-name>
  yum install docker-ce -y
  systemctl start docker && systemctl enable docker
```

##  (2)部署kubelet组件

在节点 192.168.3.4和192.168.3.6 上执行

```
  kublet 运行在每个 worker 节点上，接收 kube-apiserver 发送的请求，管理 Pod 容器，执行交互式命令，如exec、run、logs 等; kublet 启动时自动向 kube-apiserver 注册节点信息，内置的 cadvisor 统计和监控节点的资源使用情况; 为确保安全，只开启接收 https 请求的安全端口，对请求进行认证和授权，拒绝未授权的访问(如apiserver、heapster)
  
```

### (1)安装二进制文件

在节点 192.168.3.4和192.168.3.6 上执行

``` bash
  wget https://dl.k8s.io/v1.13.1/kubernetes-node-linux-amd64.tar.gz
  tar zxvf kubernetes-node-linux-amd64.tar.gz
  cd kubernetes/node/bin/
  cp kube-proxy kubelet kubectl /k8s/kubernetes/bin/
```

### (2)复制相关证书到node节点
 
``` bash
  scp *.pem 192.168.3.6:$PWD   
```

### (3)创建kubelet bootstrap kubeconfig文件 通过脚本实现

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

### (4)执行脚本

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

### (5)创建kubelet参数配置模板文件

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

### (6)创建kubelet配置文件

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

### (7)创建kubelet systemd文件
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

### (8)将kubelet-bootstrap用户绑定到系统集群角色

``` bash
  kubectl create clusterrolebinding kubelet-bootstrap \
    --clusterrole=system:node-bootstrapper \
    --user=kubelet-bootstrap
```

### (9)启动kubelet服务

``` bash
  systemctl daemon-reload 
  systemctl enable kubelet 
  systemctl start kubelet
```


### (10)Master接受kubelet CSR请求 可以手动或自动 approve CSR 请求。推荐使用自动的方式，因为从 v1.8 版本开始，可以自动轮转approve csr 后生成的证书，如下是手动 approve CSR请求操作方法 查看CSR列表

``` bash
  kubectl get csr
  NAME                                                   AGE    REQUESTOR           CONDITION
  node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc   102s   kubelet-bootstrap   Pending
```

### (11)接受node
 
 ``` bash
 
 kubectl certificate approve node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc
  certificatesigningrequest.certificates.k8s.io/node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc approved

 ```
 
 ### (12)再查看csr
 
  ``` bash
  kubectl get csr
  NAME                                                   AGE     REQUESTOR           CONDITION
  node-csr-ij3py9j-yi-eoa8sOHMDs7VeTQtMv0N3Efj3ByZLMdc   5m13s   kubelet-bootstrap   Approved,Issued
 ```
 
 ### (13)部署kube-proxy组件
 
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

### (14)创建kube-proxy systemd文件
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

### (15)启动kube-proxy服务
``` bash
  systemctl daemon-reload 
  systemctl enable kube-proxy 
  systemctl start kube-proxy
  systemctl status kube-proxy
```

### (16)查看集群状态
``` bash
 kubectl get nodes
 
 NAME        STATUS   ROLES    AGE     VERSION
192.168.3.4   Ready    <none>   9m15s   v1.13.0
192.168.3.6   Ready    <none>   9m15s   v1.13.0
 
 ```
