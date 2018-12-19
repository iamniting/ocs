# it creates a nginx app pod
# it takes two arguments
# $1 is name of the pod
# $2 is name of pvc
# eg. sh nginx-create.sh 001 claim001


name=$1
claimName=$2

echo "apiVersion: v1
kind: Pod
metadata:
  name: nginx$name
spec:
  containers:
    - image: nginx
      command:
        - sleep
        - '3600'
      name: nginx
      volumeMounts:
        - mountPath: /usr/share/nginx
          name: mypvc
  volumes:
    - name: mypvc
      persistentVolumeClaim:
        claimName: $claimName" | oc create -f -
