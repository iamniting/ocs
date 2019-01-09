#!/bin/bash
### This script is responsible for setting volume options on gluster for mongodb file volume
### eg. sh set-vol-ops-file-mongodb.sh


pvcName=mongodb-001
glusterfsNameSpace=glusterfs
nameSpace=mongodb

podName=`oc get pods -n $glusterfsNameSpace -l glusterfs=storage-pod | awk '{print $1}' | tail -n 1`
pvName=`oc -n $nameSpace get pvc $pvcName -o=custom-columns=:.spec.volumeName --no-headers`
volName=`oc -n $nameSpace get pv $pvName -o=custom-columns=:.spec.glusterfs.path --no-headers`

volOps="performance.client-io-threads on
nfs.disable on
transport.address-family inet
cluster.choose-local false
server.event-threads 4
client.event-threads 4
performance.read-after-open yes
performance.readdir-ahead off
performance.read-ahead off
performance.io-cache off
performance.strict-o-direct on
performance.quick-read off
performance.open-behind on
performance.stat-prefetch off"

oc -n $glusterfsNameSpace exec -i $podName -- bash -c "gluster v info $volName"

echo

while read -r line; do
    echo setting vol option $line
    oc exec -n $glusterfsNameSpace $podName -- gluster v set $volName $line
done <<< "$volOps"
