#!/bin/bash

### it creates secret for glusterfs
### eg. sh glusterfs-secret.sh


name=heketi-storage-secret-glusterfs
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
