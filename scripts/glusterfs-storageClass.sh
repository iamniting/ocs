# it creates storageClass for glusterfs
# eg. sh glusterfs-storageClass.sh


name=glusterfs-sc
secretname=heketi-secret-glusterfs
secretnamespace=glusterfs
resturl=`oc get service heketi-storage -n $secretnamespace --no-headers\
    -o=custom-columns=:.spec.clusterIP`

echo "apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: $name
reclaimPolicy: Delete
provisioner: kubernetes.io/glusterfs
parameters:
  resturl: http://$resturl:8080
  restuser: admin
  secretName: $secretname
  secretNamespace: $secretnamespace
  volumeoptions: user.heketi.arbiter true,user.heketi.average-file-size 64
  volumenameprefix: vol
allowVolumeExpansion: true" | oc create -f -
