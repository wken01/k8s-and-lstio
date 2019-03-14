kubectl describe node

---------------------------------------------------------------------------------------------------------------------
```
Name:               192.168.1.160
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=192.168.1.160
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 11 Mar 2019 11:08:42 +0800
Taints:             <none>
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Thu, 14 Mar 2019 11:38:22 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 14 Mar 2019 11:38:22 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 14 Mar 2019 11:38:22 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 14 Mar 2019 11:38:22 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.1.160
  Hostname:    192.168.1.160
Capacity:
 cpu:                6
 ephemeral-storage:  51175Mi
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32624812Ki
 pods:               110
Allocatable:
 cpu:                6
 ephemeral-storage:  48294789041
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32522412Ki
 pods:               110
System Info:
 Machine ID:                 57284f078c0d462daf5613d080adf09c
 System UUID:                69599E7B-0812-EA75-010D-0C9D92C90D93
 Boot ID:                    ed089df4-40c9-4142-abe6-339c4dc3b187
 Kernel Version:             3.10.0-957.el7.x86_64
 OS Image:                   CentOS Linux 7 (Core)
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://18.9.3
 Kubelet Version:            v1.13.0
 Kube-Proxy Version:         v1.13.0
Non-terminated Pods:         (2 in total)
  Namespace                  Name                             CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                             ------------  ----------  ---------------  -------------  ---
  kys                        service-test-7b84885df5-8qw8k    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
  kys                        service-test-7b84885df5-smlhg    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests  Limits
  --------           --------  ------
  cpu                0 (0%)    0 (0%)
  memory             0 (0%)    0 (0%)
  ephemeral-storage  0 (0%)    0 (0%)
Events:              <none>


Name:               192.168.1.170
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=192.168.1.170
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 11 Mar 2019 11:25:36 +0800
Taints:             <none>
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Thu, 14 Mar 2019 11:39:24 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 14 Mar 2019 11:39:24 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 14 Mar 2019 11:39:24 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 14 Mar 2019 11:39:24 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.1.170
  Hostname:    192.168.1.170
Capacity:
 cpu:                6
 ephemeral-storage:  51175Mi
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32624808Ki
 pods:               110
Allocatable:
 cpu:                6
 ephemeral-storage:  48294789041
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32522408Ki
 pods:               110
System Info:
 Machine ID:                 d5970981c5a043a2a2722f52fe937b39
 System UUID:                24D8B430-D0F8-5F28-3EAD-0C9D92C90D7B
 Boot ID:                    ad768294-0b5f-4e0a-bb4b-96180e767d4a
 Kernel Version:             3.10.0-957.el7.x86_64
 OS Image:                   CentOS Linux 7 (Core)
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://18.9.3
 Kubelet Version:            v1.13.0
 Kube-Proxy Version:         v1.13.0
Non-terminated Pods:         (4 in total)
  Namespace                  Name                             CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                             ------------  ----------  ---------------  -------------  ---
  kube-system                coredns-dc8bbbcf9-cf49n          100m (1%)     0 (0%)      70Mi (0%)        170Mi (0%)     44h
  kys                        busybox                          0 (0%)        0 (0%)      0 (0%)           0 (0%)         43h
  kys                        service-test-7b84885df5-54rsv    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
  kys                        service-test-7b84885df5-z2hdl    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests   Limits
  --------           --------   ------
  cpu                100m (1%)  0 (0%)
  memory             70Mi (0%)  170Mi (0%)
  ephemeral-storage  0 (0%)     0 (0%)
Events:              <none>
[root@k8s-master yaml]# kubectl describe node kys-node-1
Error from server (NotFound): nodes "kys-node-1" not found
[root@k8s-master yaml]# kubectl describe kys-node-1
error: the server doesn't have a resource type "kys-node-1"
[root@k8s-master yaml]# kubectl describe node
Name:               192.168.1.160
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=192.168.1.160
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 11 Mar 2019 11:08:42 +0800
Taints:             <none>
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Thu, 14 Mar 2019 11:39:12 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 14 Mar 2019 11:39:12 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 14 Mar 2019 11:39:12 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 14 Mar 2019 11:39:12 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.1.160
  Hostname:    192.168.1.160
Capacity:
 cpu:                6
 ephemeral-storage:  51175Mi
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32624812Ki
 pods:               110
Allocatable:
 cpu:                6
 ephemeral-storage:  48294789041
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32522412Ki
 pods:               110
System Info:
 Machine ID:                 57284f078c0d462daf5613d080adf09c
 System UUID:                69599E7B-0812-EA75-010D-0C9D92C90D93
 Boot ID:                    ed089df4-40c9-4142-abe6-339c4dc3b187
 Kernel Version:             3.10.0-957.el7.x86_64
 OS Image:                   CentOS Linux 7 (Core)
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://18.9.3
 Kubelet Version:            v1.13.0
 Kube-Proxy Version:         v1.13.0
Non-terminated Pods:         (2 in total)
  Namespace                  Name                             CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                             ------------  ----------  ---------------  -------------  ---
  kys                        service-test-7b84885df5-8qw8k    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
  kys                        service-test-7b84885df5-smlhg    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests  Limits
  --------           --------  ------
  cpu                0 (0%)    0 (0%)
  memory             0 (0%)    0 (0%)
  ephemeral-storage  0 (0%)    0 (0%)
Events:              <none>


Name:               192.168.1.170
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=192.168.1.170
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 11 Mar 2019 11:25:36 +0800
Taints:             <none>
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Thu, 14 Mar 2019 11:40:15 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 14 Mar 2019 11:40:15 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 14 Mar 2019 11:40:15 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 14 Mar 2019 11:40:15 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.1.170
  Hostname:    192.168.1.170
Capacity:
 cpu:                6
 ephemeral-storage:  51175Mi
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32624808Ki
 pods:               110
Allocatable:
 cpu:                6
 ephemeral-storage:  48294789041
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32522408Ki
 pods:               110
System Info:
 Machine ID:                 d5970981c5a043a2a2722f52fe937b39
 System UUID:                24D8B430-D0F8-5F28-3EAD-0C9D92C90D7B
 Boot ID:                    ad768294-0b5f-4e0a-bb4b-96180e767d4a
 Kernel Version:             3.10.0-957.el7.x86_64
 OS Image:                   CentOS Linux 7 (Core)
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://18.9.3
 Kubelet Version:            v1.13.0
 Kube-Proxy Version:         v1.13.0
Non-terminated Pods:         (4 in total)
  Namespace                  Name                             CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                             ------------  ----------  ---------------  -------------  ---
  kube-system                coredns-dc8bbbcf9-cf49n          100m (1%)     0 (0%)      70Mi (0%)        170Mi (0%)     44h
  kys                        busybox                          0 (0%)        0 (0%)      0 (0%)           0 (0%)         43h
  kys                        service-test-7b84885df5-54rsv    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
  kys                        service-test-7b84885df5-z2hdl    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests   Limits
  --------           --------   ------
  cpu                100m (1%)  0 (0%)
  memory             70Mi (0%)  170Mi (0%)
  ephemeral-storage  0 (0%)     0 (0%)
Events:              <none>
[root@k8s-master yaml]# clear
[root@k8s-master yaml]# kubectl describe node
Name:               192.168.1.160
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=192.168.1.160
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 11 Mar 2019 11:08:42 +0800
Taints:             <none>
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Thu, 14 Mar 2019 11:39:42 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 14 Mar 2019 11:39:42 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 14 Mar 2019 11:39:42 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 14 Mar 2019 11:39:42 +0800   Mon, 11 Mar 2019 11:08:08 +0800   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.1.160
  Hostname:    192.168.1.160
Capacity:
 cpu:                6
 ephemeral-storage:  51175Mi
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32624812Ki
 pods:               110
Allocatable:
 cpu:                6
 ephemeral-storage:  48294789041
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32522412Ki
 pods:               110
System Info:
 Machine ID:                 57284f078c0d462daf5613d080adf09c
 System UUID:                69599E7B-0812-EA75-010D-0C9D92C90D93
 Boot ID:                    ed089df4-40c9-4142-abe6-339c4dc3b187
 Kernel Version:             3.10.0-957.el7.x86_64
 OS Image:                   CentOS Linux 7 (Core)
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://18.9.3
 Kubelet Version:            v1.13.0
 Kube-Proxy Version:         v1.13.0
Non-terminated Pods:         (2 in total)
  Namespace                  Name                             CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                             ------------  ----------  ---------------  -------------  ---
  kys                        service-test-7b84885df5-8qw8k    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
  kys                        service-test-7b84885df5-smlhg    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests  Limits
  --------           --------  ------
  cpu                0 (0%)    0 (0%)
  memory             0 (0%)    0 (0%)
  ephemeral-storage  0 (0%)    0 (0%)
Events:              <none>


Name:               192.168.1.170
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=192.168.1.170
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 11 Mar 2019 11:25:36 +0800
Taints:             <none>
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Thu, 14 Mar 2019 11:40:45 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 14 Mar 2019 11:40:45 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 14 Mar 2019 11:40:45 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 14 Mar 2019 11:40:45 +0800   Mon, 11 Mar 2019 11:26:04 +0800   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.1.170
  Hostname:    192.168.1.170
Capacity:
 cpu:                6
 ephemeral-storage:  51175Mi
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32624808Ki
 pods:               110
Allocatable:
 cpu:                6
 ephemeral-storage:  48294789041
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             32522408Ki
 pods:               110
System Info:
 Machine ID:                 d5970981c5a043a2a2722f52fe937b39
 System UUID:                24D8B430-D0F8-5F28-3EAD-0C9D92C90D7B
 Boot ID:                    ad768294-0b5f-4e0a-bb4b-96180e767d4a
 Kernel Version:             3.10.0-957.el7.x86_64
 OS Image:                   CentOS Linux 7 (Core)
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://18.9.3
 Kubelet Version:            v1.13.0
 Kube-Proxy Version:         v1.13.0
Non-terminated Pods:         (4 in total)
  Namespace                  Name                             CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                             ------------  ----------  ---------------  -------------  ---
  kube-system                coredns-dc8bbbcf9-cf49n          100m (1%)     0 (0%)      70Mi (0%)        170Mi (0%)     44h
  kys                        busybox                          0 (0%)        0 (0%)      0 (0%)           0 (0%)         43h
  kys                        service-test-7b84885df5-54rsv    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
  kys                        service-test-7b84885df5-z2hdl    0 (0%)        0 (0%)      0 (0%)           0 (0%)         19h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests   Limits
  --------           --------   ------
  cpu                100m (1%)  0 (0%)
  memory             70Mi (0%)  170Mi (0%)
  ephemeral-storage  0 (0%)     0 (0%)
Events:              <none>

```