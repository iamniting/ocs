# This script is used for run workload on amq pod
# eg. sh run-workload-amq.sh


# variables
name=broker-001
nameSpace=amq
messageCount=1000
messageSize=1000
iterations=10

outputFile=output-amq-messageCount-$messageCount-messageSize-$messageSize.$$

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

# draw results
timeMS=`cat $outputFile | grep "milli second" | awk '{print $10}'`
echo "****** $outputFile ******" | tee -a results
echo "****** $iterations transactins per second ******" | tee -a results
echo $timeMS | tee -a results

iter=`echo $timeMS | wc -w`
sum=`cat $outputFile | grep "milli second" | awk '{print $10}' | paste -sd+ | bc`
res=`echo $sum/$iter | bc`
echo "average time in milli second -> $res" | tee -a results
echo | tee -a results
