```
  创建一个pod
kubectl create -f /opt/memory-request-limit.yaml --namespace=k8s-test

查看所有pod状态
kubectl get pods --show-labels --all-namespaces

查看pod状态
kubectl get pod memory-demo --show-labels --namespace=k8s-test

查看pod（能查询到具体错误状态信息,事件列表）
kubectl describe pod memory-demo --namespace=k8s-test

查看pod日志
kubectl logs memory-demo --namespace=k8s-test

查看pod详细状态信息
kubectl get pod memory-demo --output=yaml --namespace=k8s-test

查看pod的更多详细信息
kubectl get pod <pod-name> -o wide

以yaml格式显示Pod的详细信息
kubectl get pod <pod-name> -o yaml

以yaml文件形式显示一个pod的详细信息
kubectl get po pod-redis -o yaml

查看pod的变化
kubectl get --watch pod test-projected-volume --namespace=k8s-test

查看pod yaml完整定义
 kubectl get pods/qos-demo -o yaml --namespace=k8s-test

强制重启pod
kubectl get pod coredns-dc8bbbcf9-cf49n -n kube-system -o yaml | kubectl replace --force -f -


删除pod
kubectl delete pod memory-demo --namespace=k8s-test

批量删除pod
kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod

更新pod
 kubectl apply -f auth.yaml
 或
 kubectl edit deployment pigx-auth -n kys

（5）使用一些复杂过滤条件查看特定的资源对象

根据重启次数排序列出 pod
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

获取所有具有 app=cassandra 的 pod 中的 version 标签
kubectl get pods --selector=app=cassandra rc -o  jsonpath='{.items[*].metadata.labels.version}'
```
