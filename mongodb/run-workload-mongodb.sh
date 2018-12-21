# This script is used for run load on mongodb pod
# eg. sh run-workload-mongodb.sh


threads=10
recordcount=100
operationcount=100
iterations=10
output_file=output-mongodb

namespace=mongodb
mongodb_deploymentconfig=mongodb-001
ycsb_deploymentconfig=ycsb-001

mongodb_pod_name=`oc -n $namespace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$mongodb_deploymentconfig`
ycsb_pod_name=`oc -n $namespace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$ycsb_deploymentconfig`
mongodb_ip=`oc -n $namespace get pods -o=custom-columns=:.status.podIP --no-headers=true --selector deploymentconfig=$mongodb_deploymentconfig`

G='\033[1;32m'
N='\033[0m'

for i in $(seq 1 $iterations); do
    echo -e "\nRunning iteration $i" | tee -a $output_file
    # delete database
    echo -e "\n${G}Deleting Database${N}"
    echo -e "\nDeleting existing database" >> $output_file
    (time oc -n $namespace exec -i $mongodb_pod_name -- bash -c "scl enable rh-mongodb32 -- mongo -u redhat -p redhat $mongodb_ip:27017/sampledb --eval 'db.usertable.remove({})'") 2>&1 |& tee -a $output_file

    # load or create database
    echo -e "\n${G}Loading Database${N}"
    echo -e "\nLoading database" >> $output_file
    (time oc -n $namespace exec -i $ycsb_pod_name -- bash -c "./bin/ycsb load mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodb_ip:27017/sampledb -p recordcount=$recordcount -p operationcount=$operationcount") 2>&1 |& tee -a $output_file

    # run or updating database
    echo -e "\n${G}Updating Database${N}"
    echo -e "\nUpdating database" >> $output_file
    (time oc -n $namespace exec -i $ycsb_pod_name -- bash -c "./bin/ycsb run mongodb -s -threads $threads -P "workloads/workloadf" -p mongodb.url=mongodb://redhat:redhat@$mongodb_ip:27017/sampledb -p recordcount=$recordcount -p operationcount=$operationcount") 2>&1 |& tee -a $output_file
done

echo "*************************************************************************" >> $output_file
