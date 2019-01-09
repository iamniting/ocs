#!/bin/bash

### it creates a storageClass for gluster-block
### eg. sh block-storageClass.sh


name=block-sc
secretName=heketi-secret-block
secretNameSpace=glusterfs
restUrl=`oc get service heketi-storage -n $secretNameSpace --no-headers\
    -o=custom-columns=:.spec.clusterIP`

echo "apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: $name
reclaimPolicy: Delete
provisioner: gluster.org/glusterblock
parameters:
  resturl: http://$restUrl:8080
  restuser: admin
  restsecretName: $secretName
  restsecretNamespace: $secretNameSpace
  hacount: '3'
  chapauthenabled: 'true'
  volumenameprefix: blk" | oc create -f -
