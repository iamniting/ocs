#!/bin/bash
### This script is used for run load on mongodb pod
### eg. sh run-workload-mongodb.sh


mongodbDC=mongodb-001
ycsbDC=ycsb-001
nameSpace=mongodb
threads=10
recordCount=1000
operationCount=1000
iterations=10

outputFile=output-mongodb-threads-$threads-recordCount-$recordCount-operationCount-$operationCount.$$

mongodbPodName=`oc -n $nameSpace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$mongodbDC`
ycsbPodName=`oc -n $nameSpace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$ycsbDC`
mongodbIP=`oc -n $nameSpace get pods -o=custom-columns=:.status.podIP --no-headers=true --selector deploymentconfig=$mongodbDC`

G='\033[1;32m'
N='\033[0m'

for i in $(seq 1 $iterations); do
    echo -e "\n------ Running iteration $i ------" | tee -a $outputFile
    ### delete database
    echo -e "\n${G}Deleting Database${N}"
    echo -e "\n****** Deleting existing database ******" >> $outputFile
    (time oc -n $nameSpace exec -i $mongodbPodName -- bash -c \
        "scl enable rh-mongodb32 -- mongo -u redhat -p redhat $mongodbIP:27017/sampledb --eval 'db.usertable.remove({})'") 2>&1 |& tee -a $outputFile

    ### load or create database
    echo -e "\n${G}Loading Database${N}"
    echo -e "\n****** Loading database ******" >> $outputFile
    (time oc -n $nameSpace exec -i $ycsbPodName -- bash -c \
        "./bin/ycsb load mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodbIP:27017/sampledb -p recordcount=$recordCount \
        -p operationcount=$operationCount") 2>&1 |& tee -a $outputFile

    ### run or updating database
    echo -e "\n${G}Updating Database${N}"
    echo -e "\n****** Updating database ******" >> $outputFile
    (time oc -n $nameSpace exec -i $ycsbPodName -- bash -c \
        "./bin/ycsb run mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodbIP:27017/sampledb -p recordcount=$recordCount \
        -p operationcount=$operationCount") 2>&1 |& tee -a $outputFile
done

echo "*************************************************************************" >> $outputFile

### draw results
throughPutLoad=`cat $outputFile | grep Throughput | awk '{print $3}' | awk 'NR%2==1'`
throughPutRun=`cat $outputFile | grep Throughput | awk '{print $3}' | awk 'NR%2==0'`
echo "****** $outputFile ******" | tee -a results-mongodb
echo "****** $iterations throughPut ops per second for Load ******" | tee -a results-mongodb
echo $throughPutLoad | tee -a results-mongodb
echo "****** $iterations throughPut ops per second for Run ******" | tee -a results-mongodb
echo $throughPutRun | tee -a results-mongodb

iter=`echo $throughPutLoad | wc -w`
sum=`cat $outputFile | grep Throughput | awk '{print $3}' | awk 'NR%2==1' | paste -sd+ | bc`
res=`echo $sum/$iter | bc`
echo "average throughput(ops/sec) for Load -> $res" | tee -a results-mongodb

iter=`echo $throughPutRun | wc -w`
sum=`cat $outputFile | grep Throughput | awk '{print $3}' | awk 'NR%2==0' | paste -sd+ | bc`
res=`echo $sum/$iter | bc`
echo "average throughput(ops/sec) for Run -> $res" | tee -a results-mongodb

echo | tee -a results-mongodb
