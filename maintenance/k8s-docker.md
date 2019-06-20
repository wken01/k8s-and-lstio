
```

docker相关



容器和镜像原理

1.安装docker
http://www.runoob.com/docker/centos-docker-install.html


各种命令掌握



2.列出docker 和 docker 镜像

docker version
docker info  --查看dockeer 具体信息，包括加速器信息，总内存，存储，日志，网络

docker ps -l --查看最后运行的容器
docker ps -a --查看所有容器
docker ps    --查看所有运行的容器
docker stats -a 查看所有容器运行状态
docker stats 70ccc226ec07 查看某一个容易运行状态
docker logs -f --tail 100 4f8185117103 日志（4f8185117103 通过docker ps获取）
docker inspect 4f8185117103 查看容器详细信息

docker images -a --列出所有镜像

3.从官方搜索docker

 sudo docker search centos

4.拉取镜像

docker pull learn/tutorial

5.在容器中运行命令
docker run learn/tutorial echo "hello word"
docker run registry.cn-hangzhou.aliyuncs.com/tomcattest/tomcat:5.0
docker run -p 8080:8080 -d registry.cn-hangzhou.aliyuncs.com/tomcattest/tomcat:5.0 --后台运行
docker logs -f --tail 100 4f8185117103 日志（4f8185117103 通过docker ps获取）
docker run -t -i  registry.cn-hangzhou.aliyuncs.com/tomcattest/tomcat:5.0 /bin/bash  --进入容器

6.docker version  --查看版本号

7.docker stats -a 查看所有容器运行状态


8.执行命令

执行Pod的data命令，默认是用Pod中的第一个容器执行
kubectl exec <pod-name> data

指定Pod中某个容器执行data命令
kubectl exec <pod-name> -c <container-name> data

通过bash获得Pod中某个容器的TTY，相当于登录容器
kubectl exec -it <pod-name> -c <container-name> /bin/bash
kubectl exec -it nginx-ingress-controller-c75dc5b55-lfcvm bash -n ingress-nginx

8.容器日志

kubectl logs -f <pod-name> -n <namespace> -c <container-name>

docker logs containerId

9.添加docker官方docker 地址的拉去速度

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://e4dqxm01.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker


10.查看docker 启动日志

journalctl -u docker.service


几个速度比较快的镜像地址

Docker 官方中国区: https://registry.docker-cn.com

网易: http://hub-mirror.c.163.com

中科大: https://docker.mirrors.ustc.edu.cn

```
