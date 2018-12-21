# This script is used for run workload on amq pod
# eg. sh run-workload-amq.sh


# variables
name=broker-001
nameSpace=amq
iterations=10
messageCount=1000
messageSize=1000
outputFile=output-amq

G='\033[1;32m'
N='\033[0m'

echo | tee -a $outputFile

for i in $(seq 1 $iterations); do
    podName=`oc get pods -n $nameSpace --no-headers=true --selector statefulset.kubernetes.io/pod-name=amq-$name-0 -o=custom-columns=:.metadata.name`
    echo -e "${G}Running transactions on database${N}"
    echo "------ Running iteration $i ------" | tee -a $outputFile

    echo "****** Producing Messages ******" | tee -a $outputFile
    (time oc -n $nameSpace exec -i $podName -- bash -c "./broker/bin/artemis producer --message-count=$messageCount --message-size=$messageSize")  2>&1 |& tee -a $outputFile
    echo | tee -a $outputFile

    echo "****** Consuming Messages ******" | tee -a $outputFile
    (time oc -n $nameSpace exec -i $podName -- bash -c "./broker/bin/artemis consumer --message-count=$messageCount")  2>&1 |& tee -a $outputFile
    echo | tee -a $outputFile
done

echo "*************************************************************************" >> $outputFile
