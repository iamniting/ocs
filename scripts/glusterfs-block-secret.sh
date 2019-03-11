#!/bin/bash

### it creates a secret for gluster-block
### eg. sh glusterfs-block-secret.sh


name=heketi-storage-secret-glusterfs-block
nameSpace=glusterfs
adminkey='adminkey'

key=`echo -n $adminkey | base64`

echo "apiVersion: v1
kind: Secret
metadata:
  name: $name
  namespace: $nameSpace
data:
  key: $key
type: gluster.org/glusterblock" | oc create -f -
