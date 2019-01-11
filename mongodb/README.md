## Configure mongodb pod on openshift container platform using ocs pvc claim

Goto mongodb directory
```
# cd ocs/mongodb
```

## Configuring and running workload using scripts

Edit the following parameters in the deploy-mongodb.sh file to suite your cluster / requirements
```
name -> This is the name of the deployement config which gets created
nameSpace -> A new namespace which gets created where mongodb will be deployed.
storageClass -> Name of the storageclass 
```

If you are deploying it for the first time then please make sure to uncomment the line below from the deploy-mongodb.sh file
```
oc tag registry.access.redhat.com/rhscl/mongodb-32-rhel7 mongodb:3.2 -n openshift; oc import-image mongodb:3.2 -n openshift &
```
Run the following command to deploy mongodb and ycsb
```
# sh deploy-mongodb.sh
# sh ycsb.sh ycsb
```

Run the following command to start workload on the mongodb pod (make sure to have right parameters for mongodbDC,ycsbDC & namespace)
```
# sh run-workload-mongodb.sh
```

## Below steps explains the manual procedure about deploying and running workloads on mongodb pods

Create new-app from the template                                                
```                                                                             
# oc new-app mongodb.yaml -p DATABASE_SERVICE_NAME=mongodb -p MEMORY_LIMIT=1Gi -p VOLUME_CAPACITY=10Gi -p STORAGE_CLASS=glusterfs-storage
```                                                                             
                                                                                
Verify that pod is up and running                                               
```                                                                             
# oc get pods
```

## Configure YCSB pod to run workload on mongodb

Create DC of YCSB pod
```
# sh ycsb.sh ycsb
```

Verify that pod is up and running
```
# oc get pods
```

## Run workload on mongodb pod

Get the IP of mongodb pod
```
# oc get pods -o wide
```

Go inside the mongodb pod
```
# oc rsh pod_name
```

Delete databse ($mongodb_ip is a IP of mongodb pod)
```
# scl enable rh-mongodb32 -- mongo -u redhat -p redhat $mongodb_ip:27017/sampledb --eval 'db.usertable.remove({})'
```

Go inside the ycsb pod
```
# oc rsh pod_name
```

Load database ($recordcount, $operationcount can be an integer & $mongodb_ip is a IP of mongodb pod)
```
# ./bin/ycsb load mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodb_ip:27017/sampledb -p recordcount=$recordcount -p operationcount=$operationcount
```

Run transactions on database ($recordcount, $operationcount can be an integer & $mongodb_ip is a IP of mongodb pod)
```
# ./bin/ycsb run mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodb_ip:27017/sampledb -p recordcount=$recordcount -p operationcount=$operationcount
```
