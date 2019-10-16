#!/usr/bin/env bash
cd ~/jakarta-ee-microprofile-workshop/application-server-project/
mvn clean package
docker build -t localhost:32000/application-server-project .
docker push localhost:32000/application-server-project
sed -i 's#application-server-project:latest#localhost:32000/application-server-project:latest#g' kubernetes/application-server-project.yml
microk8s.kubectl apply -f kubernetes/application-server-project.yml
sed -i 's#localhost:32000/application-server-project:latest#application-server-project:latest#g' kubernetes/application-server-project.yml
cd -
