# This script is used for run load on pgsql pod
# eg. sh run-workload-pgsql.sh


# variables
pgsqlDC=postgresql-001
nameSpace=pgsql
scaling=800
clients=10
threads=2
transactions=1000
iterations=10

outputFile=output-pgsql-scaling-$scaling-clients-$clients-threads-$threads-transactions-$transactions.$$
podName=`oc -n $nameSpace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$pgsqlDC`

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
    podName=`oc -n $nameSpace get pods -o=custom-columns=:.metadata.name --no-headers=true --selector deploymentconfig=$pgsqlDC`
    echo -e "\n${G}Running transactions on database${N}"
    echo "------ Running iteration $i ------" | tee -a $outputFile
    (time oc -n $nameSpace exec -i $podName -- bash -c "pgbench -c $clients -j $threads -t $transactions sampledb")  2>&1 |& tee -a $outputFile
    echo | tee -a $outputFile
done

echo "*************************************************************************" >> $outputFile

# draw results
transactions=`cat $outputFile | grep tps | grep including | awk '{print $3}'`
echo "****** $outputFile ******" | tee -a results-pgsql
echo "****** $iterations transactins per second ******" | tee -a results-pgsql
echo $transactions | tee -a results-pgsql

iter=`echo $transactions | wc -w`
sum=`cat $outputFile | grep tps | grep including | awk '{print $3}' | paste -sd+ | bc`
res=`echo $sum/$iter | bc`
echo "average tps -> $res" | tee -a results-pgsql
echo | tee -a results-pgsql
