#!/usr/bin/bash
systemctl stop etcd
systemctl daemon-reload
rm -rf /var/lib/etcd
rm -rf /usr/lib/systemd/system/etcd.service
rm -rf /k8s/etcd
rm -rf /data1
