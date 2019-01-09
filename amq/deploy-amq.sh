#!/bin/bash

### This script is responsible for deploying amq pod
### eg. sh deploy-amq.sh


### variables
name=broker-001
nameSpace=amq
storageClass=glusterfs-sc
volumeCapacity=10Gi

R='\033[1;31m'
G='\033[1;32m'
N='\033[0m'

echo -e "\n${G}Creating new project $nameSpace${N}"
oc create ns $nameSpace

echo -e "\n${G}Creating a $name SVC, STS, Route${N}"
oc new-app amq.yaml -n $nameSpace -p APPLICATION_NAME=$name -p STORAGE_CLASS=$storageClass -p VOLUME_CAPACITY=$volumeCapacity

echo -e "\n${G}Waiting for pvc to be bound for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    var="$(oc get pvc -n $nameSpace pvol-amq-$name-0 -o=custom-columns=:.status.phase --no-headers)"
    if [ "${var}" == 'Bound' ]; then
        echo "PVC pvol-amq-$name-0 is in Bound state"
        break
    fi
    echo "PVC pvol-amq-$name-0 is still in Pending state"
done

echo -e "\n${G}Waiting for pod to be ready for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    podName="$(oc get pods -n $nameSpace --no-headers=true --selector statefulset.kubernetes.io/pod-name=amq-$name-0 -o=custom-columns=:.metadata.name)"
    var="$(oc get pods -n $nameSpace --no-headers=true --selector statefulset.kubernetes.io/pod-name=amq-$name-0 -o=custom-columns=:.status.containerStatuses[0].ready)"
    if [ "${var}" == 'true' ]; then
        echo "Pod $podName is ready"
        break
    fi
    echo "Waiting for Pod $podName to be ready"
done
