# This script is responsible for deploying mongodb pod
# eg. sh deploy-mongodb.sh


# variables
NAME=mongodb-001
STORAGE_CLASS=glusterfs-sc
NAMESPACE=mongodb
VOLUME_CAPACITY=200Gi
MEMORY_LIMIT=8192Mi

R='\033[1;31m'
G='\033[1;32m'
N='\033[0m'

echo -e "\n${G}Creating new project $NAMESPACE${N}"
oc create ns $NAMESPACE

echo -e "\n${G}Creating a $NAME Secret, SVC, PVC, DC${N}"
oc new-app mongodb.yaml -n $NAMESPACE -p DATABASE_SERVICE_NAME=$NAME -p STORAGE_CLASS=$STORAGE_CLASS -p VOLUME_CAPACITY=$VOLUME_CAPACITY -p MEMORY_LIMIT=$MEMORY_LIMIT

echo -e "\n${G}Waiting for pvc to be bound for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    var="$(oc get pvc -n $NAMESPACE $NAME -o=custom-columns=:.status.phase --no-headers)"
    if [ "${var}" == 'Bound' ]; then
        echo "PVC $NAME is in Bound state"
        break
    fi
    echo "PVC $NAME is still in Pending state"
done

echo -e "\n${G}Waiting for pod to be ready for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    pod_name="$(oc get pods -n $NAMESPACE --no-headers=true --selector deploymentconfig=$NAME -o=custom-columns=:.metadata.name)"
    var="$(oc get pods -n $NAMESPACE --no-headers=true --selector deploymentconfig=$NAME -o=custom-columns=:.status.containerStatuses[0].ready)"
    if [ "${var}" == 'true' ]; then
        echo "Pod $pod_name is ready"
        break
    else
        echo "Waiting for Pod $pod_name to be ready"
    fi
done
