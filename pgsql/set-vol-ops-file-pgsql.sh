#!/bin/bash

### This script is responsible for setting volume options on gluster for postgresql file volume
### eg. sh set-vol-ops-file-pgsql.sh


pvcName=postgresql-001
glusterfsNameSpace=glusterfs
nameSpace=pgsql

podName=`oc get pods -n $glusterfsNameSpace -l glusterfs=storage-pod | awk '{print $1}' | tail -n 1`
pvName=`oc -n $nameSpace get pvc $pvcName -o=custom-columns=:.spec.volumeName --no-headers`
volName=`oc -n $nameSpace get pv $pvName -o=custom-columns=:.spec.glusterfs.path --no-headers`

volOps="diagnostics.count-fop-hits on
diagnostics.latency-measurement on
cluster.choose-local false
server.event-threads 4
performance.read-after-open yes
client.event-threads 4
performance.readdir-ahead off
performance.io-cache off
performance.read-ahead off
performance.strict-o-direct on
performance.quick-read off
performance.open-behind on
performance.write-behind off
performance.stat-prefetch off
transport.address-family inet
nfs.disable on
performance.client-io-threads on"

oc -n $glusterfsNameSpace exec -i $podName -- bash -c "gluster v info $volName"

echo

while read -r line; do
    echo setting vol option $line
    oc exec -n $glusterfsNameSpace $podName -- gluster v set $volName $line
done <<< "$volOps"
