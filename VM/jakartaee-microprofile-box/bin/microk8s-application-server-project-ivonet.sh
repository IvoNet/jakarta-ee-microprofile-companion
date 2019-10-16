#!/usr/bin/env bash
cd ~/jakarta-ee-microprofile-workshop/application-server-project/
mvn clean package
docker build -t ivonet/application-server-project:latest .
docker push ivonet/application-server-project:latest
sed -i 's#application-server-project:latest#ivonet/application-server-project:latest#g' kubernetes/application-server-project.yml
microk8s.kubectl apply -f kubernetes/application-server-project.yml
sed -i 's#ivonet/application-server-project:latest#application-server-project:latest#g' kubernetes/application-server-project.yml
cd -
