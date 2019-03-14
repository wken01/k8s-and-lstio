
nginx-dev.yaml

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
