#!/bin/bash

### it creates a DC of cirros pod
### it takes two argument
### $1 is name of the dc and pod
### $2 is name of the pvc
### eg. sh cirros-create-without-io.sh 001 claim001


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
        livenessProbe:
          exec:
            command:
            - 'sh'
            - '-ec'
            - 'df /mnt'
          initialDelaySeconds: 3
          periodSeconds: 3
  replicas: 1
  triggers:
    - type: 'ConfigChange'
  paused: false
  revisionHistoryLimit: 2" | oc create -f -
