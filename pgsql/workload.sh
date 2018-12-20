# This script is used for run load on pgsql pod
# eg. sh run-workload.sh


# variables
deploymentconfig=postgresql-001
namespace=pgsql
scaling=800
clients=10
threads=2
transactions=1000
iterations=11
output_file=output-pgsql

pod_name=`oc -n $namespace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$deploymentconfig`

G='\033[1;32m'
N='\033[0m'

# delete database
echo -e "\n${G}Deleting existing database${N}"
echo -e "\nDeleting existing database" >> $output_file
(time oc -n $namespace exec -i $pod_name -- bash -c "dropdb sampledb") 2>&1 |& tee -a $output_file

# create database
echo -e "\n${G}Creating new database${N}"
echo -e "\nCreating new database" >> $output_file
(time oc -n $namespace exec -i $pod_name -- bash -c "createdb sampledb") 2>&1 |& tee -a $output_file

# scale up database
echo -e "\n${G}Scaling up database $scaling times${N}"
echo -e "\nScaling up database $scaling times" >> $output_file
(time oc -n $namespace exec -i $pod_name -- bash -c "pgbench -i -s $scaling sampledb")  2>&1 |& tee -a $output_file
echo "" | tee -a $output_file

for i in $(seq 1 $iterations); do
    # run load
    pod_name=`oc -n $namespace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$deploymentconfig`
    echo -e "\n${G}Running transactions on database${N}"
    echo "Running iteration $i" | tee -a $output_file
    (time oc -n $namespace exec -i $pod_name -- bash -c "pgbench -c $clients -j $threads -t $transactions sampledb")  2>&1 |& tee -a $output_file
    echo "" | tee -a $output_file
done

echo "*************************************************************************" >> $output_file
