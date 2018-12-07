## install mongodb pod on openshift container platform using ocs pvc claim

Create a template mongodb-persistent-glusterfs
```
# cd ocs/mongodb
```

```                                                                             
# oc create -f mongodb.yaml                                  
```                                                                             
                                                                                
Create new-app from the template                                                
```                                                                             
# oc new-app mongodb-persistent-glusterfs -p DATABASE_SERVICE_NAME=mongodb -p MEMORY_LIMIT=1Gi -p VOLUME_CAPACITY=10Gi -p STORAGE_CLASS=glusterfs-storage
```                                                                             
                                                                                
Verify that pod is up and running                                               
```                                                                             
# oc get pods
```

## install YCSB pod

Create DC of YCSB pod
```
# sh ycsb.sh ycsb
```

Verify that pod is up and running
```
# oc get pods
```

## Run test on mongodb pod

Get the IP of mongodb pod
```
# oc get pods -o wide
```

Go inside the mongodb pod
```
# oc rsh pod_name
```

Delete databse
```
# scl enable rh-mongodb32 -- mongo -u redhat -p redhat $mongodb_ip:27017/sampledb --eval 'db.usertable.remove({})'
```

Go inside the ycsb pod
```
# oc rsh pod_name
```

Load database ($recordcount, $operationcount can be an integer)
```
# ./bin/ycsb load mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodb_ip:27017/ sampledb -p recordcount=$recordcount -p operationcount=$operationcount
```

Run transactions on database ($recordcount, $operationcount can be an integer)
```
# ./bin/ycsb run mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodb_ip:27017/  sampledb -p recordcount=$recordcount -p operationcount=$operationcount
```
