
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
