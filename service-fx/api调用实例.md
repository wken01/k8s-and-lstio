curl http://localhost:8080/api/v1/namespaces/kys/services/service-test
cutl -k https://192.168.1.150:6443/api/v1/namespaces/kys/services/service-test
在浏览器中 https://192.168.1.150:6443/api/v1/namespaces/kys/services/service-test 可以下载到service-test.json

这里边selftLink 就是真实的api 地址
``` bash
	{
	  "kind": "Service",
	  "apiVersion": "v1",
	  "metadata": {
		"name": "service-test",
		"namespace": "kys",
		"selfLink": "/api/v1/namespaces/kys/services/service-test",
		"uid": "f7e9af76-4568-11e9-a4ef-0c9d92c90f4f",
		"resourceVersion": "252626",
		"creationTimestamp": "2019-03-13T08:21:14Z"
	  },
	  "spec": {
		"ports": [
		  {
			"protocol": "TCP",
			"port": 8088,
			"targetPort": 8080
		  }
		],
		"selector": {
		  "app": "service_test_pod"
		},
		"clusterIP": "10.254.82.218",
		"type": "ClusterIP",
		"sessionAffinity": "None"
	  },
	  "status": {
		"loadBalancer": {
		  
		}
	  }
```
