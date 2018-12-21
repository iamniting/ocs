# This script is used for run load on amq pod
# eg. sh run-workload-amq.sh


# variables
statefulset=broker-001
namespace=amq
iterations=11
output_file=output-amq

G='\033[1;32m'
N='\033[0m'

echo | tee -a $output_file

for i in $(seq 1 $iterations); do
    # run load
    pod_name=`oc get pods -n $namespace --no-headers=true --selector statefulset.kubernetes.io/pod-name=amq-$NAME-0 -o=custom-columns=:.metadata.name`
    echo -e "\n${G}Running transactions on database${N}"
    echo "Running iteration $i" | tee -a $output_file
    echo "Producing Messages" | tee -a $output_file
    (time oc -n $namespace exec -i $pod_name -- bash -c "/broker/bin/artemis producer")  2>&1 |& tee -a $output_file
    echo "Consuming Messages" | tee -a $output_file
    (time oc -n $namespace exec -i $pod_name -- bash -c "/broker/bin/artemis consumer")  2>&1 |& tee -a $output_file
    echo | tee -a $output_file
done

echo "*************************************************************************" >> $output_file
