
nginx-dev.yaml

一种方式：通过pod创建service

``` bash

	kind: Deployment
	metadata:
	  name: mynginx
	  namespace: kys
	  labels:
		app: nginx
	spec:
	  replicas: 1
	  selector:
		matchLabels:
		  app: nginx
	  template:
		metadata:
		  labels:
			app: nginx
		spec:
		  containers:
		  - name: nginx
			image: nginx
			ports:
			- containerPort: 80
		
```

创建service

```
	kubectl expose deployment mynginx -n kys --type=NodePort
```


测试，通过curl或浏览器访问，能返回nginx页面

```
	curl http://192.168.1.160:34158/
```


另外一种创建方式：通过pod 根据yml文件的形式创建service

注意
```
	(1)NodePort必须通过firewalld通过，
	(2)几个端口的概念，以及和pod的对应关系
		port 是暴露暴露在cluster ip上的端口，<cluster ip>:port 是提供给集群内部客户访问service的入口
		nodePort是kubernetes提供给集群外部客户访问service入口的一种方式（另一种方式是LoadBalancer），所以，<nodeIP>:nodePort 是提供给集群外部客户访问service的入口
		targetPort很好理解，targetPort是pod上的端口，从port和nodePort上到来的数据最终经过kube-proxy流入到后端pod的targetPort上进入容器。
		
		port和nodePort都是service的端口，前者暴露给集群内客户访问服务，后者暴露给集群外客户访问服务。从这两个端口到来的数据都需要经过反向代理kube-proxy流入后端pod的targetPod，从而到达pod上的容器内。
		
		使用Userspace模式（k8s版本为1.2之前默认模式），外部网络可以直接访问cluster IP。 
		使用Iptables模式（k8s版本为1.2之后默认模式），外部网络不能直接访问cluster IP。
	(3)targetPort 一定要和pod中的ports-name对应
```

pod_nginx.yaml
``` bash
	apiVersion: v1
	kind: Pod
	metadata:
	  name: nginx-pod
	  namespace: kys
	  labels:
		app: nginx
	spec:
	  containers:
	  - name: nginx-container
		image: nginx
		ports:
		- name: nginx-port
		  containerPort: 80
```

nginx-service.yaml

``` bash
	apiVersion: v1
	kind: Service
	metadata:
	  name: nginx-service
	  namespace: kys
	spec:
	  ports:
	  - port: 8899
		nodePort: 30001
		targetPort: nginx-port
		protocol: TCP
	  selector:
		app: nginx
	  type: NodePort
```

结果：
``` bash
	curl http://192.168.1.160:30001/
```

