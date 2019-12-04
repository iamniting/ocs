#!/bin/bash

### it creates a endpoint
### it takes two arguments
### $1 is name of the ep
### $2 is ips of glusterfs nodes
### eg. sh ep-create.sh ep1 ip1,ip2,ip3


name=$1
ips=`echo $2 | sed -e 's/,/}, {ip: /g' -e 's/^/[{ip: /g' -e 's/$/}]/g'`

echo "kind: 'Endpoints'
apiVersion: 'v1'
metadata:
  name: '$name'
subsets:
- addresses: $ips
  ports:
  - port: 1
    protocol: TCP" | oc create -f -
