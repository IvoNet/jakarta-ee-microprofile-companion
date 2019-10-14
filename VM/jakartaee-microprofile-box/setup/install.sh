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
   unzip \
   docker.io \
   docker-compose \
   qemu-kvm \
   qemu-utils \
   maven \
   nginx


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
cat <<EOF >/etc/docker/daemon.json
{
  "insecure-registries" : ["192.168.10.100:32000", "192.168.10.100:8888"]
}
EOF
systemctl restart docker.socket docker.service
systemctl daemon-reload
systemctl restart docker
# Start docker registry ui
su - vagrant -c "docker run -d --name ui -p 8888:80 -e REGISTRY_TITLE=\"Docker Registry\" -e REGISTRY_URL=\"http://192.168.10.100:32000\" joxit/docker-registry-ui:static"

# Micro kubernetes
snap install microk8s --classic
sed -i 's/--insecure-bind-address=127.0.0.1/--insecure-bind-address=0.0.0.0/g' /var/snap/microk8s/current/args/kube-apiserver
usermod -a -G microk8s vagrant
microk8s.start
microk8s.status --wait-ready
microk8s.enable dns
microk8s.enable storage
microk8s.enable dashboard
microk8s.enable registry
microk8s.status --wait-ready

# Pre-pull some images to make network unnecessary
docker pull alpine:latest
docker pull alpine:3.9
docker pull alpine:edge
docker pull openjdk:13-jdk-alpine
docker pull openjdk:8u212-jdk-slim
docker pull ivonet/payara:5.193
docker pull payara/server-full
docker pull payara/micro:5.193
docker pull jboss/wildfly:latest
docker pull mysql:5.7.27
docker pull phpmyadmin/phpmyadmin:4.7
docker pull nginx
docker pull python:3.7.4-alpine3.10
docker pull busybox

su - vagrant -c "git clone https://github.com/ederks85/jakarta-ee-microprofile-workshop.git"
su - vagrant -c "mvn install clean -f jakarta-ee-microprofile-workshop/pom.xml"
rm -rfv application-server-project/artifact

# Configure nginx
/home/vagrant/bin/nginx-config.sh

# Cleanup
apt-get clean

