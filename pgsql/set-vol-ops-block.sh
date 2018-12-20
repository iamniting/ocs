# This script is responsible for setting volume options on gluster for postgresql block volume
# eg. sh set-vol-ops-block.sh


glusterfs_ns=glusterfs
block_host_vol_name=vol_b077bdbe9a26e192efb6f5c497e60c37

gluster_pod_name=`oc get pods -n $glusterfs_ns -l glusterfs=storage-pod | awk '{print $1}' | tail -n 1`

vol_ops="cluster.choose-local off
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

oc -n $glusterfs_ns exec -i $gluster_pod_name -- bash -c "gluster v info $block_host_vol_name"

echo

while read -r line
do
    echo setting vol option $line
    oc exec -n $glusterfs_ns $gluster_pod_name -- gluster v set $block_host_vol_name $line
done <<< "$vol_ops"
