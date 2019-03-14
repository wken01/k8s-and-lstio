
service-test.yaml

``` bash

	apiVersion:  apps/v1
	kind: Deployment
	metadata:
	  name: service-test
	  namespace: kys
	spec:
	  replicas: 4
	  selector:
		matchLabels:
		  app: service_test_pod
	  template:
		metadata:
		  labels:
			app: service_test_pod
		spec:
		  containers:
		  - name: simple-http
			image: python:2.7
			imagePullPolicy: Never
			command: ["/bin/bash"]
			args: ["-c", "echo \"<p>Hello from $(hostname)</p>\" > index.html; python -m SimpleHTTPServer 8080"]
			ports:
			- name: http
			  containerPort: 8080
```

通过kubectl expose给刚才这个deployment创建一个service，端口绑定为8088.

```
	kubectl expose deployment service-test --port 8088 --target-port=8080 -n kys
```