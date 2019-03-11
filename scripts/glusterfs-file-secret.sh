#!/bin/bash

### it creates secret for glusterfs
### eg. sh glusterfs-file-secret.sh


name=heketi-storage-secret-glusterfs-file
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
type: kubernetes.io/glusterfs" | oc create -f -
