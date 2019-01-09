## Configure jenkins pod on openshift container platform using ocs pvc claim

Goto jenkins directory
```
# cd ocs/jenkins
```

## Configuring using scripts

Edit the following parameters in the deploy-jenkins.sh file to suite your cluster / requirements
```
JENKINS_NAME -> This is the name of the deployement config which gets created
JJB_CM_NAME -> This is the name of the configmap which gets created
JJB_DC_NAME -> This is the name of the deployement config which gets created
NAMESPACE -> A new namespace which gets created where jenkins will be deployed.
STORAGECLASS -> Name of the storageclass
```

Run the following command to deploy jenkins
```
# sh deploy-jenkins.sh
```

## Below steps explains the manual procedure about deploying the jenkins pod

Create jenkins pod
```
# oc new-app jenkins.yaml -p JENKINS_SERVICE_NAME=jenkins -p JNLP_SERVICE_NAME=jenkins -p MEMORY_LIMIT=1Gi -p VOLUME_CAPACITY=10Gi -p STORAGE_CLASS=glusterfs-storage
```

Create jjb configmap
```
# oc new-app cm-jjb.yaml -p NAME=jjb-configmap -p JENKINS_URL=<jenkins route>
```

Create jjb pod
```
# oc new-app dc-jjb.yaml -p NAME=jjb -p JJB_CM=jjb-configmap
```
