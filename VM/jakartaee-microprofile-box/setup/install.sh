#!/usr/bin/env bash
#set -x
# Environment
chmod -x /etc/update-motd.d/10-help-text
chmod -x /etc/update-motd.d/50-motd-news
chmod -x /etc/update-motd.d/80-*
chmod -x /etc/update-motd.d/9?-*
cat <<EOF >/etc/update-motd.d/10-ivonet
#!/bin/sh
cat <<EOT

     _____     _ _                 ____
    | ____|___| (_)_ __  ___  ___ / ___|___  _ __
    |  _| / __| | | '_ \/ __|/ _ \ |   / _ \| '_ \\\\
    | |__| (__| | | |_) \__ \  __/ |__| (_) | | | |
    |_____\___|_|_| .__/|___/\___|\____\___/|_| |_|
                  |_|

  Welcome to the Jakarta EE - MicroProfile - workshop
  
  Created by:
  * Ivo Woltring  (@ivonet)
  * Talip Ozkeles (@tozkeles)
  * Edwin Derks   (@edwinderks)

EOT
EOF
chmod +x /etc/update-motd.d/10-ivonet

# Update aptitude
apt-get update
apt-get upgrade -y

#snap install docker

# Base dependencies
apt-get install -q -y \
   python3-pip \
   cowsay \
   docker.io \
   docker-compose \
   unzip \
   qemu-kvm \
   qemu-utils \
   maven

# https://github.com/moby/moby/issues/20554
apt-get install --reinstall apparmor
#ln -s /etc/apparmor.d/docker /etc/apparmor.d/disable/docker
#systemctl daemon-reload
#systemctl restart docker.socket docker.service
#systemctl restart docker

#https://stackoverflow.com/questions/50151833/cannot-login-to-docker-account
#https://github.com/docker/cli/issues/1136
mkdir -p /home/vagrant/.docker 2>/dev/null
mv /usr/bin/docker-credential-secretservice /usr/bin/docker-credential-secretservice.bak
chown -R vagrant:vagrant /home/vagrant/.docker

# Docker without sudo...
usermod -aG docker vagrant
systemctl restart docker.socket docker.service
systemctl daemon-reload
systemctl restart docker

# Pre-pull some images to make network unnecessary
docker pull alpine:latest
docker pull alpine:3.9
docker pull alpine:edge
docker pull openjdk:13-jdk-alpine
docker pull openjdk:8u212-jdk-slim
docker pull ivonet/payara:5.193
docker pull payara/server-full
docker pull jboss/wildfly:latest
docker pull mysql:5.7.27
docker pull phpmyadmin/phpmyadmin:4.7
docker pull nginx
docker pull python:3.7.4-alpine3.10
docker pull busybox

# Some helpful commands in the history
history -s "docker ps -a"
history -s "docker run -it --rm --name sh alpine:3.9 /bin/sh"
history -s "docker run -p 8080:8080 -p 4848:4848 payara/server-full"

# Micro kubernetes
snap install microk8s --classic
sudo sed -i 's/--insecure-bind-address=127.0.0.1/--insecure-bind-address=0.0.0.0/g' /var/snap/microk8s/current/args/kube-apiserver

# minikube
#curl -sLo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
#chmod +x /usr/local/bin/minikube
#snap install minikube

# kubectl
curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl
snap install kubectl --classic

# Cleanup
apt-get clean

