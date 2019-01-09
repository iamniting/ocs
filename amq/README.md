## Configure amq-broker pod on openshift container platform using ocs pvc claim

Goto amq directory
```                                                                             
# cd ocs/amq                                                    
```                                                                             

## Configuring and running workload using scripts

Edit the following parameters in the deploy-amq.sh file to suite your cluster / requirements
```
name -> This is the name of the app pod which gets created
nameSpace -> A new namespace which gets created where amq will be deployed.
storageClass -> Name of the storageclass 
```

Run the following command to deploy amq
```
# sh deploy-amq.sh
```

Run the following command to start workload on the amq pod (make sure to have right parameters for name, & namespace)
```
# sh run-workload-amq.sh
```
                                                                               
## Below steps explains the manual procedure about deploying and running workloads on amq pods

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
