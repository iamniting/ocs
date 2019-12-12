#!/bin/bash

### it creates a DC of cirros pod
### it takes three arguments
### -d is name of the dc and pod
### -v is name of the volume
### -e is name of endpoint
### eg. sh cirros-create-with-untar-kernel.sh -d=dc1 -v=vol1 -e=ep1


get_args() {
    for i in "$@"; do
        case $i in
            -d=*|--dc=*)
                DC_NAME="${i#*=}"
                ;;

            -v=*|--vol=*)
                VOL_NAME="${i#*=}"
                ;;

            -e=*|--ep=*)
                EP_NAME="${i#*=}"
                ;;

            *)
                echo 'unknown option' "${i}" | cut -d '=' -f 1
                echo "\"${i}\""
                exit 255
                ;;
        esac
    done
}

create_dc() {
echo "kind: 'DeploymentConfig'
apiVersion: 'v1'
metadata:
  name: '$DC_NAME'
spec:
  template:
    metadata:
      labels:
        name: '$DC_NAME'
    spec:
      restartPolicy: 'Always'
      volumes:
      - glusterfs:
          endpoints: $EP_NAME
          path: $VOL_NAME
        name: cirros-volume
      containers:
      - name: 'cirros'
        image: 'cirros:latest'
        imagePullPolicy: 'IfNotPresent'
        volumeMounts:
        - mountPath: '/mnt'
          name: cirros-volume
        command: ['sh', '-c', 'wget http://ftp.riken.jp/Linux/kernel.org/linux/kernel/v4.x/linux-4.0.tar.gz -P /mnt;
            while sleep 5; do rm -rf /mnt/linux-4.0; sleep 5; zcat /mnt/linux-4.0.tar.gz | tar -xvf - -C /mnt; done']
        livenessProbe:
          initialDelaySeconds: 3
          periodSeconds: 3
          exec:
            command: ['sh', '-ec', 'touch /mnt/file; rm -rf /mnt/file']
  replicas: 1
  triggers:
    - type: 'ConfigChange'
  paused: false
  revisionHistoryLimit: 2" | oc create -f -
}

get_args $@
create_dc
