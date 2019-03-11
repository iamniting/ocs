#!/bin/bash

### it creates a pvc
### it takes two arguments
### $1 is name of the pvc
### $2 is size of pvc
### eg. sh pvc-create.sh claim001 1


name=$1
storageSize=$2
storageClass=glusterfs-file


echo "kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: $name
  annotations:
    volume.beta.kubernetes.io/storage-class: $storageClass
spec:
  accessModes:
   - ReadWriteOnce
  resources:
    requests:
      storage: $storageSize""Gi" | oc create -f -
