#!/bin/bash

# This script is responsible for deploying pgsql pod
# eg. sh deploy-pgsql.sh


# variables
JENKINS_NAME=jenkins-001
JJB_CM_NAME=jjb-configmap-001
JJB_DC_NAME=jjb-001
NAMESPACE=jenkins
STORAGECLASS=glusterfs-sc
VOLUMECAPACITY=10Gi
MEMORYLIMIT=8192Mi

# oc tag registry.access.redhat.com/openshift3/jenkins-2-rhel7 jenkins:2 -n openshift; oc import-image jenkins:2 -n openshift &

function deploy_jenkins_and_jjb() {
    ### create namespace
    oc create ns $NAMESPACE
    echo

    ### create jenkins pod
    oc new-app jenkins.yaml -n $NAMESPACE \
        -p JENKINS_SERVICE_NAME=$JENKINS_NAME -p JNLP_SERVICE_NAME=$JENKINS_NAME -p STORAGE_CLASS=$STORAGECLASS -p VOLUME_CAPACITY=$VOLUMECAPACITY -p MEMORY_LIMIT=$MEMORYLIMIT
    echo

    jenkinsUrl="$(oc get route -n $NAMESPACE $JENKINS_NAME --no-headers -o=custom-columns=:.spec.host)"

    ### create jjb configmap
    oc new-app cm-jjb.yaml -n $NAMESPACE -p NAME=$JJB_CM_NAME -p JENKINS_URL=https://$jenkinsUrl
    echo

    ### create jjb deployment config
    oc new-app dc-jjb.yaml -n $NAMESPACE -p NAME=$JJB_DC_NAME -p JJB_CM=$JJB_CM_NAME
}

function delete_jenkins() {
    oc delete dc $JENKINS_NAME
    oc delete route $JENKINS_NAME
    oc delete pvc $JENKINS_NAME
    oc delete serviceaccount $JENKINS_NAME
    oc delete rolebinding.authorization.openshift.io $JENKINS_NAME"_edit"
    oc delete service $JENKINS_NAME $JENKINS_NAME-jnlp

    oc delete dc $JJB_DC_NAME
    oc delete configmap $JJB_CM_NAME

    # oc delete ns $NAMESPACE
}

deploy_jenkins_and_jjb
# delete_jenkins
