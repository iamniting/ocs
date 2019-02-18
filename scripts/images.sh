#!/bin/bash

### it pull all docker images
### eg. sh images.sh


docker pull rhel7/etcd:3.2.22 &

docker pull openshift3/ose-node:v3.11 &
docker pull openshift3/ose-haproxy-router:v3.11 &
docker pull openshift3/ose-deployer:v3.11 &
docker pull openshift3/ose-control-plane:v3.11 &
docker pull openshift3/ose-web-console:v3.11 &
docker pull openshift3/ose-docker-registry:v3.11 &
docker pull openshift3/ose-pod:v3.11 &

docker pull openshift3/oauth-proxy:v3.11 &
docker pull openshift3/registry-console:v3.11 &

docker pull openshift3/logging-fluentd:v3.11 &
docker pull openshift3/logging-curator:v3.11 &
docker pull openshift3/logging-auth-proxy:v3.11 &
docker pull openshift3/logging-kibana:v3.11 &
docker pull openshift3/logging-elasticsearch:v3.11 &

docker pull openshift3/metrics-heapster:v3.11 &
docker pull openshift3/metrics-hawkular-metrics:v3.11 &
docker pull openshift3/metrics-cassandra:v3.11 &
docker pull openshift3/metrics-schema-installer:v3.11 &

docker pull rhgs3/rhgs-server-rhel7:v3.11 &
docker pull rhgs3/rhgs-volmanager-rhel7:v3.11 &
docker pull rhgs3/rhgs-gluster-block-prov-rhel7:v3.11 &
