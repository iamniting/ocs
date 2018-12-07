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
