# it creates a DC of cirros pod
# it takes two argument
# $1 is name of the dc and pod
# $2 is name of the pvc
# eg. sh cirros-create.sh 001 claim001
# we can also change the size of file in line no. 39, It takes bytes eg. "head -c 2000 < /dev/urandom > /mnt/random-data.log"


name=$1
claimName=$2

echo "kind: 'DeploymentConfig'
apiVersion: 'v1'
metadata:
  name: 'cirros$name'
spec:
  template:
    metadata:
      labels:
        name: 'cirros$name'
    spec:
      restartPolicy: 'Always'
      volumes:
      - name: 'cirros-vol'
        persistentVolumeClaim:
          claimName: '$claimName'
      containers:
      - name: 'cirros'
        image: 'cirros'
        imagePullPolicy: 'IfNotPresent'
        volumeMounts:
        - mountPath: '/mnt'
          name: 'cirros-vol'
        command: ['sh']
        args:
        - '-ec'
        - 'while true; do
               (mount | grep /mnt) && (head -c 1000 < /dev/urandom > /mnt/random-data.log) || exit 1;
               sleep 20 ;
           done'
        livenessProbe:
          exec:
            command:
            - 'sh'
            - '-ec'
            - 'mount | grep /mnt && head -c 1024 < /dev/urandom >> /mnt/random-data.log'
          initialDelaySeconds: 3
          periodSeconds: 3
  replicas: 1
  triggers:
    - type: 'ConfigChange'
  paused: false
  revisionHistoryLimit: 2" | oc create -f -
