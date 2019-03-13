
# 部署coredns

## 1 创建coredns.yaml

``` bash
  cd /opt/kubernetes/cluster/addons/dns/coredns/
  cp coredns.yaml.base coredns.yaml
  vim coredns.yaml
  
  
```

2.修改其中3个地方

``` bash
 
 (1) clusterIP: 10.254.0.10 
 apiVersion: v1
  kind: Service
  metadata:
    name: kube-dns
    namespace: kube-system
    annotations:
      prometheus.io/port: "9153"
      prometheus.io/scrape: "true"
    labels:
      k8s-app: kube-dns
      kubernetes.io/cluster-service: "true"
      addonmanager.kubernetes.io/mode: Reconcile
      kubernetes.io/name: "CoreDNS"
  spec:
    selector:
      k8s-app: kube-dns
    clusterIP: 10.254.0.10
    ports:
    - name: dns
      port: 53
      protocol: UDP
    - name: dns-tcp
      port: 53
      protocol: TCP

 (2) image 要修改为coredns/coredns:1.2.6
 image: coredns/coredns:1.2.6
 
 （3） Corefile这里要修改为kubernetes cluster.local 10.254.0.0/16
 Corefile: |
    .:53 {
        errors
        health
        kubernetes cluster.local 10.254.0.0/16 {
          pods insecure
          upstream
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        forward . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }
    
    执行，kubectl apply -f coredns.yaml
```

3.验证coredns

