## Configure jenkins pod on openshift container platform using ocs pvc claim

Goto jenkins directory
```
# cd ocs/jenkins
```

Create new-app from the template
```
# oc new-app jenkins.yaml -p JENKINS_SERVICE_NAME=jenkins -p JNLP_SERVICE_NAME=jenkins -p STORAGE_CLASS=glusterfs-storage -p VOLUME_CAPACITY=10Gi -p MEMORY_LIMIT=1Gi
```

Create jjb configmap
```
# oc new-app cm-jjb.yaml -p NAME=jjb-configmap -p JENKINS_URL=<jenkins route>
```

Create jjb pod
```
# oc new-app dc-jjb.yaml -p NAME=jjb -p JJB_CM=jjb-configmap
```
