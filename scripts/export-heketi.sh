# it export the heketi variables
# eg. sh export-heketi.sh


namespace=glusterfs
resturl=`oc get service heketi-storage -n $namespace --no-headers\
    -o=custom-columns=:.spec.clusterIP`

export HEKETI_CLI_SERVER=http://${resturl}:8080
export HEKETI_CLI_USER=admin
export HEKETI_CLI_KEY=adminkey

heketi-cli volume list
