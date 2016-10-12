#!/bin/bash

# Configuration

. ./config.sh

echo "	--> Log into openshift"
oc login ${OPENSHIFT_PRIMARY_MASTER}:8443 --username=${OPENSHIFT_PRIMARY_USER} --password=${OPENSHIFT_PRIMARY_USER_PASSWORD} --insecure-skip-tls-verify=false
! [ $? == 0 ] && echo "FAILED" && exit 1
echo "	--> Create a new project"
oc project ${OPENSHIFT_PRIMARY_PROJECT} || oc new-project ${OPENSHIFT_PRIMARY_PROJECT}
! [ $? == 0 ] && echo "FAILED" && exit 1

echo "	--> Create Red Hat subscription secrets"
oc get secret/red-hat-subscription 2>/dev/null || { echo ${REDHAT_SUBSCRIPTION_USER} > redhatsubcriptionuser.txt && echo ${REDHAT_SUBSCRIPTION_USER_PASSWORD} > redhatsubscriptionuserpassword.txt && echo ${REDHAT_SUBSCRIPTION_USER_POOL_ID} > redhatsubscriptionuserpoolid.txt ; oc secrets new red-hat-subscription redhatsubcriptionuser.txt redhatsubscriptionuserpassword.txt redhatsubscriptionuserpoolid.txt; } 
! [ $? == 0 ] && echo "FAILED" && exit 1

echo "	--> Add the secret to the service account created earlier"
oc describe sa/default | oc secrets add sa/default secret/red-hat-subscription
! [ $? == 0 ] && echo "FAILED" && exit 1

echo "	--> Create Red Hat subscription configmap"
if [ ! -f red-hat-subscription.yaml ] ; then
# TODO: File RFE to allow labels for ConfigMaps	-l app=${OPENSHIFT_PRIMARY_PROJECT} \
oc create configmap red-hat-subscription \
	--from-literal="redhatsubscriptionuser=${REDHAT_SUBSCRIPTION_USER}" \
	--from-literal="redhatsubscriptionuserpassword=${REDHAT_SUBSCRIPTION_USER_PASSWORD}" \
	--from-literal="redhatsubscriptionuserpoolid=${REDHAT_SUBSCRIPTION_USER_POOL_ID}" \
	-o yaml \
	> red-hat-subscription.yaml
	[ ! $? == 0 ] && echo "FAILED" && exit 1
fi
oc get configmap/red-hat-subscription  2>/dev/null || { [ -s red-hat-subscription.yaml ] && oc create -s red-hat-subscription.yaml; } 

