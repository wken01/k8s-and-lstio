```

	获取集群master 信息
	kubectl cluster-info
	kubectl cluster-info dump
	kubectl -s http://localhost:8080 get componentstatuses 

	获取节点
	kubectl get nodes


	(2).查看节点信息
	kubectl describe nodes 192.168.1.62

	(3).查看各组件健康状态
	kubectl get cs,nodes

	(4).查看日志
	more /var/log/messages  --分页显示
	less /var/log/messages  --分页显示
	systemctl status kubelet -l
	kubectl logs memory-demo --namespace=k8s-test
	journalctl -u etcd
  
```
