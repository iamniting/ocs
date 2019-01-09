## Configure pgsql pod on openshift container platform using ocs pvc claim

Goto pgsql directory
```
# cd ocs/pgsql
```

## Configuring and running workload using scripts

Edit the following parameters in the deploy-pgsql.sh file to suite your cluster / requirements
```
name -> This is the name of the deployement config which gets created
nameSpace -> A new namespace which gets created where pgsql will be deployed.
storageClass -> Name of the storageclass 
```

Run the following command to deploy pgsql
```
# sh deploy-pgsql.sh
```

Run the following command to start workload on the pgsql pod (make sure to have right parameters for pgsqlDC, & namespace)
```
# sh run-workload-pgsql.sh
```

## Below steps explains the manual procedure about deploying and running workloads on pgsql pods

Create new-app from the template
```
# oc new-app pgsql.yaml -p DATABASE_SERVICE_NAME=postgresql -p MEMORY_LIMIT=1Gi -p VOLUME_CAPACITY=10Gi -p STORAGE_CLASS=glusterfs-storage
```

Verify that pod is up and running
```
# oc get pods
```

## Run workload on postgresql pod

Go inside the pod
```
# oc rsh pod_name
```

Scaleup databse ($scaling can be any integer)
```
# pgbench -i -s $scaling sampledb
```

Run transactions on the database ($clients, $threads, $transactions can be any integer)
```
# pgbench -c $clients -j $threads -t $transactions sampledb
```

Run transactions according to time ($clients, $threads, $time can be any integer)
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
