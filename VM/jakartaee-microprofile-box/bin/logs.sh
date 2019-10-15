#!/bin/sh
if [ -z $1 ]; then
    echo "Please provide an unique part of a service name"
    exit 1
fi
PROJECT=$1
SERVICE=$(microk8s.kubectl get pods|grep Running| grep ${PROJECT}|awk '{print "pod/"$1}')
if [ -z ${SERVICE} ]; then
    echo "No service found."
    exit 1
fi
microk8s.kubectl logs ${SERVICE}
