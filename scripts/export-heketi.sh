#!/bin/bash

### it export the heketi variables
### eg. sh export-heketi.sh


nameSpace=glusterfs
heketiRoute=heketi-storage
restUrl=`oc get route $heketiRoute -n $nameSpace --no-headers\
    -o=custom-columns=:.spec.host`

export HEKETI_CLI_SERVER=http://${restUrl}
export HEKETI_CLI_USER=admin
export HEKETI_CLI_KEY=adminkey

heketi-cli volume list
