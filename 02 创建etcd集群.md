
# 安装etcd

## (1)解压安装文件

``` bash
  cd /opt/etcd-v3.3.10-linux-amd64
  cp etcd etcdctl /k8s/etcd/bin/
```

## (2)创建etcd配置文件

``` bash
  vim /k8s/etcd/cfg/etcd.conf 
    #[Member]
    ETCD_NAME="etcd01"
    ETCD_DATA_DIR="/data1/etcd"
    ETCD_LISTEN_PEER_URLS="https://192.168.3.3:2380"
    ETCD_LISTEN_CLIENT_URLS="https://192.168.3.3:2379"

    #[Clustering]
    ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.3.3:2380"
    ETCD_ADVERTISE_CLIENT_URLS="https://192.168.3.4:2379"
    ETCD_INITIAL_CLUSTER="etcd01=https://192.168.3.3:2380,etcd02=https://192.168.3.4:2380,etcd03=https://192.168.3.6:2380"
    ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
    ETCD_INITIAL_CLUSTER_STATE="new"
```

## (3)创建 etcd的 systemd unit 文件

``` bash
  vim/usr/lib/systemd/system/etcd.service.conf
  [Unit]
  Description=Etcd Server
  After=network.target
  After=network-online.target
  Wants=network-online.target

  [Service]
  Type=notify
  EnvironmentFile=/k8s/etcd/cfg/etcd
  ExecStart=/k8s/etcd/bin/etcd \
  --name=${ETCD_NAME} \
  --data-dir=${ETCD_DATA_DIR} \
  --listen-peer-urls=${ETCD_LISTEN_PEER_URLS} \
  --listen-client-urls=${ETCD_LISTEN_CLIENT_URLS},http://127.0.0.1:2379 \
  --advertise-client-urls=${ETCD_ADVERTISE_CLIENT_URLS} \
  --initial-advertise-peer-urls=${ETCD_INITIAL_ADVERTISE_PEER_URLS} \
  --initial-cluster=${ETCD_INITIAL_CLUSTER} \
  --initial-cluster-token=${ETCD_INITIAL_CLUSTER_TOKEN} \
  --initial-cluster-state=new \
  --cert-file=/k8s/etcd/ssl/server.pem \
  --key-file=/k8s/etcd/ssl/server-key.pem \
  --peer-cert-file=/k8s/etcd/ssl/server.pem \
  --peer-key-file=/k8s/etcd/ssl/server-key.pem \
  --trusted-ca-file=/k8s/etcd/ssl/ca.pem \
  --peer-trusted-ca-file=/k8s/etcd/ssl/ca.pem
  Restart=on-failure
  LimitNOFILE=65536

  [Install]
  WantedBy=multi-user.target
```

## (4)copy etcd 证书

``` bash
  cd /opt/install/ssl/etcd
  cp ca*pem server*pem /k8s/etcd/ssl
```

## (5)启动etcd 服务

``` bash
  systemctl daemon-reload
  systemctl enable etcd
  systemctl start etcd
```

## (6)将启动文件、配置文件拷贝到 节点1、节点2
``` bash
  cd /k8s/ 
  scp -r etcd 192.168.3.4:/k8s/
  scp -r etcd 192.168.3.6:/k8s/
  scp /usr/lib/systemd/system/etcd.service  192.168.3.4:/usr/lib/systemd/system/etcd.service
  scp /usr/lib/systemd/system/etcd.service  192.168.3.6:/usr/lib/systemd/system/etcd.service 

  vim /k8s/etcd/cfg/etcd 
  #[Member]
  ETCD_NAME="etcd02"
  ETCD_DATA_DIR="/data1/etcd"
  ETCD_LISTEN_PEER_URLS="https://192.168.3.4:2380"
  ETCD_LISTEN_CLIENT_URLS="https://192.168.3.4:2379"

  #[Clustering]
  ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.3.4:2380"
  ETCD_ADVERTISE_CLIENT_URLS="https://192.168.3.4:2379"
  ETCD_INITIAL_CLUSTER="etcd01=https://192.168.3.3:2380,etcd02=https://192.168.3.4:2380,etcd03=https://192.168.3.6:2380"
  ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
  ETCD_INITIAL_CLUSTER_STATE="new"

  vim /k8s/etcd/cfg/etcd.conf

  #[Member]
  ETCD_NAME="etcd03"
  ETCD_DATA_DIR="/data1/etcd"
  ETCD_LISTEN_PEER_URLS="https://192.168.3.6:2380"
  ETCD_LISTEN_CLIENT_URLS="https://192.168.3.6:2379"

  #[Clustering]
  ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.3.6:2380"
  ETCD_ADVERTISE_CLIENT_URLS="https://192.168.3.6:2379"
  ETCD_INITIAL_CLUSTER="etcd01=https://192.168.3.3:2380,etcd02=https://192.168.3.4:2380,etcd03=https://192.168.3.6:2380"
  ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
  ETCD_INITIAL_CLUSTER_STATE="new"
```

## (7)开启master 和 node上 2379 和 2380 端口
``` bash
  firewall-cmd --query-port=2379/tcp
  firewall-cmd --permanent --zone=public --add-port=2379/tcp
  firewall-cmd --query-port=2380/tcp
  firewall-cmd --permanent --zone=public --add-port=2380/tcp
  
```

## (8)验证etcd是否健康

健康检查
``` bash
  /k8s/etcd/bin/etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints="https://192.168.3.3:2379,https://192.168.3.4:2379,https://192.168.3.6:2379" cluster-health   
```

测试
``` bash
    etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints="https://192.168.3.3:2379,https://192.168.3.4:2379,https://192.168.3.6:2379" set a 1
  etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints="https://192.168.3.3:2379,https://192.168.3.4:2379,https://192.168.3.6:2379" get a
```

查询etcd leader
``` bash 
  etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints="https://192.168.3.3:2379,https://192.168.3.4:2379,https://192.168.3.6:2379" member list

```
