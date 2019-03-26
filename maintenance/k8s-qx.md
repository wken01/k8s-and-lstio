
绑定一个cluster-admin的权限

```
kubectl create clusterrolebinding system:anonymous   --clusterrole=cluster-admin   --user=system:anonymous
```
