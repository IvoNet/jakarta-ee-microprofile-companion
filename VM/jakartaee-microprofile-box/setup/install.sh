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

  Host URLs:
  * http://192.168.10.100/           : k8s API
  * http://192.168.10.100/dash       : k8s dashboard
  * http://192.168.10.100:8888       : Docker registry web

EOT
EOF
chmod +x /etc/update-motd.d/10-ivonet

# Update aptitude
apt-get update
apt-get upgrade -y

# IPTables
iptables -P FORWARD ACCEPT

#https://stackoverflow.com/questions/52706347/prevent-prompt-when-apt-install-y-iptables-persistent-on-debian-ubuntu
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections

# Base dependencies
apt-get install -q -y \
   python3-pip \
   iptables-persistent\
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
  "insecure-registries" : ["192.168.10.100:32000", "192.168.10.100:8888", "localhost:32000"]
}
EOF
systemctl restart docker.socket docker.service
systemctl daemon-reload
systemctl restart docker
# Start docker registry ui
su - vagrant -c "docker run -d --name ui --restart always -p 8888:80 -e REGISTRY_TITLE=\"Docker Registry\" -e REGISTRY_URL=\"http://192.168.10.100:32000\" joxit/docker-registry-ui:static"

# Micro kubernetes
snap install microk8s --classic
usermod -a -G microk8s vagrant
microk8s.start
microk8s.status --wait-ready
microk8s.enable dns
microk8s.enable storage
microk8s.enable dashboard
microk8s.enable registry
microk8s.status --wait-ready

# Pre-pull some images to make network unnecessary
docker pull ivonet/payara-full-jndi-quote:1.0
docker pull payara/micro:5.193
docker pull payara/server-full:5.193
docker pull ivonet/mysql-quote-db:1.0
docker pull openjdk:8u222-jre-slim
docker pull openjdk:11.0.4-jre-slim
docker pull phpmyadmin/phpmyadmin:4.7

# Checkout the project and make sure all the dependencies are already downloaded to the local registry
su - vagrant -c "git clone https://github.com/ederks85/jakarta-ee-microprofile-workshop.git" 2>/dev/null
su - vagrant -c "cd jakarta-ee-microprofile-workshop && git reset --hard && git checkout solution"
su - vagrant -c "mvn -q install clean -f jakarta-ee-microprofile-workshop/pom.xml" 2>/dev/null
rm -rfv application-server-project/artifact
su - vagrant -c "cd jakarta-ee-microprofile-workshop && git reset --hard && git checkout assignments"

# Configure nginx
/home/vagrant/bin/nginx-config.sh

# Cleanup
apt-get clean

# Microk8s information
microk8s.inspect

