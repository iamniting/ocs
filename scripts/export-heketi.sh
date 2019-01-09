#!/bin/bash

### it export the heketi variables
### eg. sh export-heketi.sh


nameSpace=glusterfs
restUrl=`oc get service heketi-storage -n $nameSpace --no-headers\
    -o=custom-columns=:.spec.clusterIP`

export HEKETI_CLI_SERVER=http://${restUrl}:8080
export HEKETI_CLI_USER=admin
export HEKETI_CLI_KEY=adminkey

heketi-cli volume list
