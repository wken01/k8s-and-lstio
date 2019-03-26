
```
查看版本
etcdctl --version

查看etcd 的健康状态
etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints=https://192.168.1.61:2379 cluster-health

测试
etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints=https://192.168.1.61:2379 set a 1
etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints=https://192.168.1.61:2379 get a

查看leader
etcdctl --ca-file=/k8s/etcd/ssl/ca.pem --cert-file=/k8s/etcd/ssl/server.pem --key-file=/k8s/etcd/ssl/server-key.pem --endpoints=https://192.168.1.61:2379 member list

```
