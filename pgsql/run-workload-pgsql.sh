# This script is used for run load on pgsql pod
# eg. sh run-workload-pgsql.sh


# variables
name=postgresql-001
nameSpace=pgsql
scaling=800
clients=10
threads=2
transactions=1000
iterations=11
outputFile=output-pgsql

podName=`oc -n $nameSpace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$name`

G='\033[1;32m'
N='\033[0m'

# delete database
echo -e "\n${G}Deleting existing database${N}"
echo -e "\n****** Deleting existing database ******" >> $outputFile
(time oc -n $nameSpace exec -i $podName -- bash -c "dropdb sampledb") 2>&1 |& tee -a $outputFile

# create database
echo -e "\n${G}Creating new database${N}"
echo -e "\n****** Creating new database ******" >> $outputFile
(time oc -n $nameSpace exec -i $podName -- bash -c "createdb sampledb") 2>&1 |& tee -a $outputFile

# scale up database
echo -e "\n${G}Scaling up database $scaling times${N}"
echo -e "\n****** Scaling up database $scaling times ******" >> $outputFile
(time oc -n $nameSpace exec -i $podName -- bash -c "pgbench -i -s $scaling sampledb")  2>&1 |& tee -a $outputFile
echo | tee -a $outputFile

for i in $(seq 1 $iterations); do
    # run load
    podName=`oc -n $nameSpace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$name`
    echo -e "\n${G}Running transactions on database${N}"
    echo "------ Running iteration $i ------" | tee -a $outputFile
    (time oc -n $nameSpace exec -i $podName -- bash -c "pgbench -c $clients -j $threads -t $transactions sampledb")  2>&1 |& tee -a $outputFile
    echo | tee -a $outputFile
done

echo "*************************************************************************" >> $outputFile
