#!/bin/bash

### it creates storageClass for glusterfs
### eg. sh glusterfs-file-storageClass.sh


name=glusterfs-file
secretName=heketi-storage-secret-glusterfs-file
secretNameSpace=glusterfs
heketiRoute=heketi-storage
restUrl=`oc get route $heketiRoute -n $secretNameSpace --no-headers\
    -o=custom-columns=:.spec.host`

echo "apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: $name
reclaimPolicy: Delete
provisioner: kubernetes.io/glusterfs
parameters:
  resturl: http://$restUrl
  restuser: admin
  secretName: $secretName
  secretNamespace: $secretNameSpace
  #volumeoptions: user.heketi.arbiter true,user.heketi.average-file-size 64
  volumenameprefix: ocs
allowVolumeExpansion: true" | oc create -f -
