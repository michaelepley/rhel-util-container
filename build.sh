#!/bin/bash

. ./config.sh

echo "Build Docker Image"

echo "	--> Run the docker build"
sudo docker build -t rhel-util/rhel7 \
  --build-arg redhatsubscriptionuser=${REDHAT_SUBSCRIPTION_USER} \
  --build-arg redhatsubscriptionuserpassword=${REDHAT_SUBSCRIPTION_USER_PASSWORD} \
  --build-arg redhatsubscriptionuserpoolid=${REDHAT_SUBSCRIPTION_USER_POOL_ID} \
  dockercontext