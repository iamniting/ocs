#!/bin/bash
### This script is responsible for setting volume options on gluster for mongodb block volume
### eg. sh set-vol-ops-block-mongodb.sh


glusterfsNameSpace=glusterfs
blockHostVolName=vol_b077bdbe9a26e192efb6f5c497e60c37

podName=`oc get pods -n $glusterfsNameSpace -l glusterfs=storage-pod | awk '{print $1}' | tail -n 1`

volOps="cluster.choose-local off
server.allow-insecure on
user.cifs off
features.shard-block-size 64MB
features.shard on
cluster.shd-wait-qlength 10000
cluster.shd-max-threads 8
cluster.locking-scheme granular
cluster.data-self-heal-algorithm full
cluster.quorum-type auto
cluster.eager-lock enable
network.remote-dio disable
performance.strict-o-direct on
performance.readdir-ahead off
performance.open-behind off
performance.stat-prefetch off
performance.io-cache off
performance.read-ahead off
performance.quick-read off
transport.address-family inet
nfs.disable on
performance.client-io-threads off"

oc -n $glusterfsNameSpace exec -i $podName -- bash -c "gluster v info $blockHostVolName"

echo

while read -r line; do
    echo setting vol option $line
    oc exec -n $glusterfsNameSpace $podName -- gluster v set $blockHostVolName $line
done <<< "$volOps"
