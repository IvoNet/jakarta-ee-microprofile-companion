#!/bin/sh
kubectl cluster-info|sed 's#https://127.0.0.1:16443#http://192.168.10.100#g'
