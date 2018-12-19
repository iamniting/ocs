# it creates a busybox app pod
# it takes two arguments
# $1 is name of the pod
# $2 is name of pvc
# eg. sh busybox-create.sh 001 claim001


name=$1
claimName=$2

echo "apiVersion: v1
kind: Pod
metadata:
  name: busybox$name
spec:
  containers:
    - image: busybox
      command:
        - sleep
        - '3600'
      name: busybox
      volumeMounts:
        - mountPath: /usr/share/busybox
          name: mypvc
  volumes:
    - name: mypvc
      persistentVolumeClaim:
        claimName: $claimName" | oc create -f -
