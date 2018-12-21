# This script is responsible for setting volume options on gluster for postgresql file volume
# eg. sh set-vol-ops-file-pgsql.sh


pvc_name=postgresql-001
glusterfs_ns=glusterfs
namespace=pgsql

gluster_pod_name=`oc get pods -n $glusterfs_ns -l glusterfs=storage-pod | awk '{print $1}' | tail -n 1`
pv_name=`oc -n $namespace get pvc $pvc_name -o=custom-columns=:.spec.volumeName --no-headers`
vol_name=`oc -n $namespace get pv $pv_name -o=custom-columns=:.spec.glusterfs.path --no-headers`

vol_ops="diagnostics.count-fop-hits on
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

oc -n $glusterfs_ns exec -i $gluster_pod_name -- bash -c "gluster v info $vol_name"

echo

while read -r line; do
    echo setting vol option $line
    oc exec -n $glusterfs_ns $gluster_pod_name -- gluster v set $vol_name $line
done <<< "$vol_ops"
