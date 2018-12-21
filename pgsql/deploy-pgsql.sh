# This script is responsible for deploying pgsql pod
# eg. sh deploy-pgsql.sh


# variables
name=postgresql-001
nameSpace=pgsql
storageClass=glusterfs-sc
volumeCapacity=200Gi
memoryLimit=8192Mi

R='\033[1;31m'
G='\033[1;32m'
N='\033[0m'

echo -e "\n${G}Creating new project $nameSpace${N}"
oc create ns $nameSpace

# oc tag registry.access.redhat.com/rhscl/postgresql-96-rhel7 postgresql:9.6 -n openshift; oc import-image postgresql:9.6 -n openshift &

echo -e "\n${G}Creating a $name Secret, SVC, PVC, DC${N}"
oc new-app pgsql.yaml -n $nameSpace -p DATABASE_SERVICE_NAME=$name -p STORAGE_CLASS=$storageClass -p VOLUME_CAPACITY=$volumeCapacity -p MEMORY_LIMIT=$memoryLimit

echo -e "\n${G}Waiting for pvc to be bound for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    var="$(oc get pvc -n $nameSpace $name -o=custom-columns=:.status.phase --no-headers)"
    if [ "${var}" == 'Bound' ]; then
        echo "PVC $name is in Bound state"
        break
    fi
    echo "PVC $name is still in Pending state"
done

echo -e "\n${G}Waiting for pod to be ready for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    podName="$(oc get pods -n $nameSpace --no-headers=true --selector deploymentconfig=$name -o=custom-columns=:.metadata.name)"
    var="$(oc get pods -n $nameSpace --no-headers=true --selector deploymentconfig=$name -o=custom-columns=:.status.containerStatuses[0].ready)"
    if [ "${var}" == 'true' ]; then
        echo "Pod $podName= is ready"
        break
    fi
    echo "Waiting for Pod $podName= to be ready"
done
