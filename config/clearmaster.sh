#!/usr/bin/bash
systemctl stop kube-apiserver kube-controller-manager kube-scheduler docker kubelet flanneld
systemctl daemon-reload
rm -rf /var/run/kubernetes
rm -rf /usr/lib/systemd/system/{kube-apiserver,kube-controller-manager,kube-scheduler,kubelet,kube-proxy,flanneld,docker}.service
rm -rf /var/lib/kubelet
rm -rf /var/lib/docker
rm -rf /var/run/flannel/
rm -rf /var/run/docker/
rm -rf /var/lib/containerd
rm -rf /var/run/containerd
rm -rf /usr/lib/systemd/system/{kubelet,docker,flanneld}.service
rm -rf /k8s
ip link del flannel.1
ip link del docker0
