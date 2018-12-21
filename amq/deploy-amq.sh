# This script is responsible for deploying amq pod
# eg. sh deploy-amq.sh


# variables
NAME=broker-001
STORAGE_CLASS=glusterfs-sc
NAMESPACE=amq
VOLUME_CAPACITY=200Gi

R='\033[1;31m'
G='\033[1;32m'
N='\033[0m'

echo -e "\n${G}Creating new project $NAMESPACE${N}"
oc create ns $NAMESPACE

echo -e "\n${G}Creating a $NAME STS${N}"
oc new-app amq.yaml -n $NAMESPACE -p APPLICATION_NAME=$NAME -p STORAGE_CLASS=$STORAGE_CLASS -p VOLUME_CAPACITY=$VOLUME_CAPACITY

echo -e "\n${G}Waiting for pvc to be bound for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    var="$(oc get pvc -n $NAMESPACE pvol-amq-$NAME-0 -o=custom-columns=:.status.phase --no-headers)"
    if [ "${var}" == 'Bound' ]; then
        echo "PVC pvol-amq-$NAME-0 is in Bound state"
        break
    fi
    echo "PVC pvol-amq-$NAME-0 is still in Pending state"
done

echo -e "\n${G}Waiting for pod to be ready for 1 minute${N}"
for i in {1..6}; do
    sleep 10
    pod_name="$(oc get pods -n $NAMESPACE --no-headers=true --selector statefulset.kubernetes.io/pod-name=amq-$NAME-0 -o=custom-columns=:.metadata.name)"
    var="$(oc get pods -n $NAMESPACE --no-headers=true --selector statefulset.kubernetes.io/pod-name=amq-$NAME-0 -o=custom-columns=:.status.containerStatuses[0].ready)"
    if [ "${var}" == 'true' ]; then
        echo "Pod $pod_name is ready"
        break
    else
        echo "Waiting for Pod $pod_name to be ready"
    fi
done
