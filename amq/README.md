## Configure amq-broker pod on openshift container platform using ocs pvc claim

Goto amq directory
```                                                                             
# cd ocs/amq                                                    
```                                                                             
                                                                                
Create new-app from the template
```
# oc new-app amq.yaml -p APPLICATION_NAME=broker -p VOLUME_CAPACITY=10Gi -p STORAGE_CLASS=glusterfs-storage
```

Verify that pod is up and running
```
# oc get pods
```

## Run workload on amq-broker pod

Go inside the pod
```
# oc rsh pod_name
```

Produce messgaes
```
# ./broker/bin/artemis producer
```

Consume messages
```
# ./broker/bin/artemis consumer
```

To see the other options for producer
```
# ./broker/bin/artemis help producer
```
