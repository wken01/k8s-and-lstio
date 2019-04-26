
--强制删除命令空间方法
get ns ingress-nginx -o json > /opt/local.json
``` bash 
{
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
        "annotations": {
            "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Namespace\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\"},\"name\":\"ingress-nginx\"}}\n"
        },
        "creationTimestamp": "2019-03-21T01:28:35Z",
        "deletionTimestamp": "2019-03-21T07:31:50Z",
        "labels": {
            "app.kubernetes.io/name": "ingress-nginx",
            "app.kubernetes.io/part-of": "ingress-nginx"
        },
        "name": "ingress-nginx",
        "resourceVersion": "1153702",
        "selfLink": "/api/v1/namespaces/ingress-nginx",
        "uid": "a56bd865-4b78-11e9-9a45-0c9d92c90f4f"
    },
    "spec": {
        "finalizers": [
            "kubernetes" #去掉这行
        ]
    },
    "status": {
        "phase": "Terminating"
    }
}
```

执行删除

''' bash
curl -H "Content-Type: application/json" -X PUT --data-binary @local.json http://127.0.0.1:8080/api/v1/namespaces/ingress-nginx/finalize

'''


```
创建命名空间
	kubectl create namespace k8s-test

	列出所有的namespaces
	kubectl get namespaces  或  kubectl get ns --show-labels
	curl http://localhost:8080/api/v1/namespaces   --api方式获取所有命令空间

	删除命令空间
	kubectl delete namespaces/ns-dev

	查看命名空间信息
	kubectl describe namespaces/ns-dev

	创建命名空间
	cat ~/k8s_install/test/ns/dev.yaml
	apiVersion: v1
	kind: Namespace
	metadata:
	  name: ns-dev
	  labels:
		name: envDev

	kubectl apply -f ~/k8s_install/test/ns/dev.yaml

	设置命令空间上下文作用？
	可以定义测试，开发，生产定义不同的命名空间，

	kubectl api-resources --namespaced=true

	执行报错：error: unable to retrieve the complete list of server APIs: metrics.k8s.io/v1beta1: the server is currently unable to handle the request

```

还有一种方法，在etcd中删除
```
ETCDCTL_API=3 etcdctl  del /registry/namespaces/kong
```
