
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

``` bash
  [root@k8s-master coredns]# kubectl get all -n kube-system
  
  NAME                          READY   STATUS    RESTARTS   AGE
  pod/coredns-dc8bbbcf9-cf49n   1/1     Running   0          23h

  NAME               TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
  service/kube-dns   ClusterIP   10.254.0.10   <none>        53/UDP,53/TCP   23h

  NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
  deployment.apps/coredns   1/1     1            1           23h

  NAME                                DESIRED   CURRENT   READY   AGE
  replicaset.apps/coredns-dc8bbbcf9   1         1         1       23h
```

新建一个 Deployment

``` bash
  cd /opt/yaml
  cat > my-nginx.yaml <<EOF
  apiVersion: extensions/v1beta1
  kind: Deployment
  metadata:
    name: my-nginx
  spec:
    replicas: 2
    template:
      metadata:
        labels:
          run: my-nginx
      spec:
        containers:
        - name: my-nginx
          image: nginx:1.7.9
          ports:
          - containerPort: 80
  EOF
  kubectl create -f my-nginx.yaml
```

Export 该 Deployment, 生成 my-nginx 服务：

``` bash
  kubectl expose deploy my-nginx
  service "my-nginx" exposed

  kubectl get services -n kys -o wide
  NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE   SELECTOR
  my-nginx      ClusterIP   10.254.8.203     <none>        80/TCP         23h   run=my-nginx
```

``` bash
  cd /opt/yaml
  cat > dnsutils-ds.yml <<EOF
  apiVersion: v1
  kind: Service
  metadata:
    name: dnsutils-ds
    labels:
      app: dnsutils-ds
  spec:
    type: NodePort
    selector:
      app: dnsutils-ds
    ports:
    - name: http
      port: 80
      targetPort: 80
  ---
  apiVersion: extensions/v1beta1
  kind: DaemonSet
  metadata:
    name: dnsutils-ds
    labels:
      addonmanager.kubernetes.io/mode: Reconcile
  spec:
    template:
      metadata:
        labels:
          app: dnsutils-ds
      spec:
        containers:
        - name: my-dnsutils
          image: tutum/dnsutils:latest
          command:
            - sleep
            - "3600"
          ports:
          - containerPort: 80
  EOF
  kubectl create -f dnsutils-ds.yml
 ```
 
 ``` bash
  $ kubectl exec dnsutils-ds-c8kcw nslookup kubernetes
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Name:   kubernetes.default.svc.cluster.local
  Address: 10.254.0.1

  $ kubectl exec dnsutils-ds-c8kcw nslookup www.baidu.com  # 解析外部域名时，需要以 . 结尾
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Non-authoritative answer:
  *** Can't find www.baidu.com: No answer

  $ kubectl exec dnsutils-ds-c8kcw nslookup www.baidu.com.
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Non-authoritative answer:
  www.baidu.com   canonical name = www.a.shifen.com.
  Name:   www.a.shifen.com
  Address: 61.135.169.125
  Name:   www.a.shifen.com
  Address: 61.135.169.121

  $ kubectl exec dnsutils-ds-c8kcw nslookup my-nginx
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Name:   my-nginx.default.svc.cluster.local
  Address: 10.254.229.163

  $ kubectl exec dnsutils-ds-c8kcw nslookup kube-dns.kube-system.svc.cluster
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Non-authoritative answer:
  *** Can't find kube-dns.kube-system.svc.cluster: No answer

  $ kubectl exec dnsutils-ds-c8kcw nslookup kube-dns.kube-system.svc
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Name:   kube-dns.kube-system.svc.cluster.local
  Address: 10.254.0.2

  $ kubectl exec dnsutils-ds-c8kcw nslookup kube-dns.kube-system.svc.cluster.local
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Non-authoritative answer:
  *** Can't find kube-dns.kube-system.svc.cluster.local: No answer

  $ kubectl exec dnsutils-ds-c8kcw nslookup kube-dns.kube-system.svc.cluster.local.
  Server:         10.254.0.10
  Address:        10.254.0.10#53

  Name:   kube-dns.kube-system.svc.cluster.local
  Address: 10.254.0.10
 ```

测试

``` bash
kubectl run curl --image=radial/busyboxplus:curl -i --tty

```
