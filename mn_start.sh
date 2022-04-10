#!/bin/bash

set -e

export CHANGE_MINIKUBE_NONE_USER=true
sudo sysctl fs.protected_regular=0

sudo -E minikube start --driver=none

# helm upgrade --install redis-operator ./redis-operator \
#     --install --namespace redis-operator

helm upgrade --install redis ./lib/helm/redis --namespace redis --create-namespace -f ./lib/helm/redis/values.yaml -f ./lib/helm/redis/my_values.yaml

minikube dashboard
