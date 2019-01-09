#!/bin/bash

### it creates secret for glusterfs
### eg. sh glusterfs-secret.sh


name=heketi-secret-glusterfs
nameSpace=glusterfs
# echo -n 'adminkey' | base64
key='YWRtaW5rZXk='

echo "apiVersion: v1
kind: Secret
metadata:
  name: $name
  namespace: $nameSpace
data:
  key: $key
type: kubernetes.io/glusterfs" | oc create -f -
