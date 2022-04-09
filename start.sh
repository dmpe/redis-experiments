#!/bin/bash

set -e

export CHANGE_MINIKUBE_NONE_USER=true
sudo sysctl fs.protected_regular=0

sudo -E minikube start --driver=none

# helm upgrade --install redis-operator ./redis-operator \
#     --install --namespace redis-operator

# helm upgrade --install redis ./redis --namespace redis-operator


minikube dashboard

