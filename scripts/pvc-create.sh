# it creates a pvc
# it takes two arguments
# $1 is name of the pvc
# $2 is size of pvc
# eg. sh pvc-create.sh claim001 1


name=$1
storage_size=$2
storage_class=glusterfs-sc


echo "kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: $name
  annotations:
    volume.beta.kubernetes.io/storage-class: $storage_class
spec:
  accessModes:
   - ReadWriteOnce
  resources:
    requests:
      storage: $storage_size""Gi" | oc create -f -
