# install pgsql pod on openshift container platform using ocs pvc claim

Create a template postgresql-persistent-glusterfs
```
# cd ocs/pgsql
```

```
# oc create -f pgsql.yaml
```

Create new-app from the template
```
# oc new-app postgresql-persistent-glusterfs -p DATABASE_SERVICE_NAME=postgresql -p MEMORY_LIMIT=1Gi -p VOLUME_CAPACITY=10Gi -p STORAGE_CLASS=glusterfs-storage
```

Verify that pod is up and running
```
# oc get pods
```

## Run test on postgresql pod

Go inside the pod
```
# oc rsh pod_name
```

Scaleup databse ($scaling can be any integer)
```
# pgbench -i -s $scaling sampledb
```

Run transactions on the database($clients, $threads, $transactions can be any integer)
```
# pgbench -c $clients -j $threads -t $transactions sampledb
```

Run transactions according to time($clients, $threads, $time can be any integer)
```
# pgbench -c $clients -j $threads -T $time sampledb
```

Delete sampledb
```
# dropdb sampledb
```

Create sampledb
```
# createdb sampledb
```
