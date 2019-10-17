#!/usr/bin/env bash
K8S_DIR="/home/vagrant/jakarta-ee-microprofile-workshop"
sed -i 's#application-server-project:latest#localhost:32000/application-server-project:latest#g' ${K8S_DIR}/application-server-project/kubernetes/application-server-project.yml
sed -i 's#hollow-jar-project:latest#localhost:32000/hollow-jar-project:latest#g' ${K8S_DIR}/hollow-jar-project/kubernetes/hollow-jar-project.yml
sed -i 's#uber-jar-project:latest#localhost:32000/uber-jar-project:latest#g' ${K8S_DIR}/uber-jar-project/kubernetes/uber-jar-project.yml

sed -i 's#IfNotPresent#Always#g' ${K8S_DIR}/application-server-project/kubernetes/application-server-project.yml
sed -i 's#IfNotPresent#Always#g' ${K8S_DIR}/hollow-jar-project/kubernetes/hollow-jar-project.yml
sed -i 's#IfNotPresent#Always#g' ${K8S_DIR}/uber-jar-project/kubernetes/uber-jar-project.yml
