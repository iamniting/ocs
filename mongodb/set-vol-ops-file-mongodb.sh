# This script is responsible for setting volume options on gluster for mongodb file volume
# eg. sh set-vol-ops-file-mongodb.sh


pvc_name=mongodb-001
glusterfs_ns=glusterfs
namespace=mongodb

gluster_pod_name=`oc -n $glusterfs_ns get pods -l glusterfs=storage-pod | awk '{print $1}' | tail -n 1`
pv_name=`oc -n $namespace get pvc $pvc_name -o=custom-columns=:.spec.volumeName --no-headers`
vol_name=`oc -n $namespace get pv $pv_name -o=custom-columns=:.spec.glusterfs.path --no-headers`

vol_ops="performance.client-io-threads on
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

oc -n $glusterfs_ns exec -i $gluster_pod_name -- bash -c "gluster v info $vol_name"

echo

while read -r line; do
    echo setting vol option $line
    oc exec -n $glusterfs_ns $gluster_pod_name -- gluster v set $vol_name $line
done <<< "$vol_ops"
