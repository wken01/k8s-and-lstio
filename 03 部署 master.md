
```
  kubernetes master 节点运行如下组件： kube-apiserver kube-scheduler kube-controller-manager kube-scheduler 
  和 kube-controller-manager 可以以集群模式运行，通过 leader 选举产生一个工作进程，
  其它进程处于阻塞模式，master三节点高可用模式下可用
 
```

##  (1) 解压缩文件
``` bash
  tar -zxvf kubernetes-server-linux-amd64.tar.gz 
  cd kubernetes/server/bin/
  cp kube-scheduler kube-apiserver kube-controller-manager kubectl /k8s/kubernetes/bin/
```

##  (2)部署kube-apiserver组件 创建TLS Bootstrapping Token

``` bash
  head -c 16 /dev/urandom | od -An -t x | tr -d ' '
  f2c50331f07be89278acdaf341ff1ecc

  vim /k8s/kubernetes/cfg/token.csv
  f2c50331f07be89278acdaf341ff1ecc,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
```

##  (3)创建Apiserver配置文件

``` bash
  vim /k8s/kubernetes/cfg/kube-apiserver.conf
  KUBE_APISERVER_OPTS="--logtostderr=true \
  --v=4 \
  --etcd-servers=https://192.168.3.3:2379,https://192.168.3.4:2379,https://192.168.3.6:2379 \
  --bind-address=192.168.3.3 \
  --secure-port=6443 \
  --advertise-address=192.168.3.3 \
  --allow-privileged=true \
  --service-cluster-ip-range=10.254.0.0/16 \
  --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \
  --authorization-mode=RBAC,Node \
  --enable-bootstrap-token-auth \
  --token-auth-file=/k8s/kubernetes/cfg/token.csv \
  --service-node-port-range=30000-50000 \
  --tls-cert-file=/k8s/kubernetes/ssl/server.pem  \
  --tls-private-key-file=/k8s/kubernetes/ssl/server-key.pem \
  --client-ca-file=/k8s/kubernetes/ssl/ca.pem \
  --service-account-key-file=/k8s/kubernetes/ssl/ca-key.pem \
  --etcd-cafile=/k8s/etcd/ssl/ca.pem \
  --etcd-certfile=/k8s/etcd/ssl/server.pem \
  --etcd-keyfile=/k8s/etcd/ssl/server-key.pem"
```

##  (4)创建apiserver systemd文件
``` bash
  vim /usr/lib/systemd/system/kube-apiserver.service 

  [Unit]
  Description=Kubernetes API Server
  Documentation=https://github.com/kubernetes/kubernetes

  [Service]
  EnvironmentFile=-/k8s/kubernetes/cfg/kube-apiserver.conf
  ExecStart=/k8s/kubernetes/bin/kube-apiserver $KUBE_APISERVER_OPTS
  Restart=on-failure

  [Install]
  WantedBy=multi-user.target
```

##  (5)启动服务
``` bash
  systemctl daemon-reload
  systemctl enable kube-apiserver
  systemctl start kube-apiserver
  systemctl status kube-apiserver
```

##  (6)部署kube-scheduler组件 创建kube-scheduler配置文件
```
  参数备注： –address：在 127.0.0.1:10251 端口接收 http /metrics 请求；kube-scheduler 目前还不支持接收 https 请求； 
  –kubeconfig：指定 kubeconfig 文件路径，kube-scheduler 使用它连接和验证 kube-apiserver； 
  –leader-elect=true：集群运行模式，启用选举功能；被选为 leader 的节点负责处理工作，其它节点为阻塞状态；
```

``` bash
  vim  /k8s/kubernetes/cfg/kube-scheduler.conf 
  KUBE_SCHEDULER_OPTS="--logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect"
``` 

##  (7)创建kube-scheduler systemd文件

``` bash
  vim /usr/lib/systemd/system/kube-scheduler.service 
 
  [Unit]
  Description=Kubernetes Scheduler
  Documentation=https://github.com/kubernetes/kubernetes

  [Service]
  EnvironmentFile=-/k8s/kubernetes/cfg/kube-scheduler.conf
  ExecStart=/k8s/kubernetes/bin/kube-scheduler $KUBE_SCHEDULER_OPTS
  Restart=on-failure

  [Install]
  WantedBy=multi-user.target
```

##  (8)启动kube-scheduler服务
``` bash
  systemctl daemon-reload
  systemctl enable kube-scheduler.service 
  systemctl start kube-scheduler.service
  systemctl status kube-scheduler
```

##  (9)部署kube-controller-manager组件 创建kube-controller-manager配置文件

``` bash
  vim /k8s/kubernetes/cfg/kube-controller-manager.conf
  KUBE_CONTROLLER_MANAGER_OPTS="--logtostderr=true \
  --v=4 \
  --master=127.0.0.1:8080 \
  --leader-elect=true \
  --address=127.0.0.1 \
  --service-cluster-ip-range=10.254.0.0/16 \
  --cluster-name=kubernetes \
  --cluster-signing-cert-file=/k8s/kubernetes/ssl/ca.pem \
  --cluster-signing-key-file=/k8s/kubernetes/ssl/ca-key.pem  \
  --root-ca-file=/k8s/kubernetes/ssl/ca.pem \
  --service-account-private-key-file=/k8s/kubernetes/ssl/ca-key.pem"
```

##  (10)创建kube-controller-manager systemd文件

vim /usr/lib/systemd/system/kube-controller-manager.service

``` bash
  [Unit]
  Description=Kubernetes Controller Manager
  Documentation=https://github.com/kubernetes/kubernetes

  [Service]
  EnvironmentFile=-/k8s/kubernetes/cfg/kube-controller-manager.conf
  ExecStart=/k8s/kubernetes/bin/kube-controller-manager $KUBE_CONTROLLER_MANAGER_OPTS
  Restart=on-failure

  [Install]
  WantedBy=multi-user.target
```

##  (11)启动kube-controller-manager 服务

``` bash
  systemctl daemon-reload
  systemctl enable kube-controller-manager
  systemctl start kube-controller-manager
  systemctl status kube-controller-manager
``` 

设置环境变量
``` bash
  vim /etc/profile
  PATH=/k8s/kubernetes/bin:$PATH
  source /etc/profile
```

查看master服务状态
``` bash
   [root@k8s-master ~]# kubectl get cs,nodes
  NAME                                 STATUS    MESSAGE             ERROR
  componentstatus/scheduler            Healthy   ok                  
  componentstatus/controller-manager   Healthy   ok                  
  componentstatus/etcd-1               Healthy   {"health":"true"}   
  componentstatus/etcd-2               Healthy   {"health":"true"}   
  componentstatus/etcd-0               Healthy   {"health":"true"}   

  NAME                 STATUS   ROLES    AGE   VERSION
  node/192.168.3.4   Ready    <none>   46h   v1.13.0
  node/192.168.3.6   Ready    <none>   46h   v1.13.0
```

