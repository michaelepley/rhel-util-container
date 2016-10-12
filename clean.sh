#!/bin/bash

# Configuration

. ./config.sh

oc delete configmap/red-hat-subscription
rm -y red-hat-subscription.yaml