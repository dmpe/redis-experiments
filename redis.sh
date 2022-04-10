#!/bin/bash

set -e 

export NODE_IP=$(sudo kubectl get nodes --namespace redis -o jsonpath="{.items[0].status.addresses[0].address}")
export NODE_PORT=$(sudo kubectl get --namespace redis -o jsonpath="{.spec.ports[0].nodePort}" services redis-master)
export REDIS_PASSWORD=$(kubectl get secret --namespace redis redis -o jsonpath="{.data.redis-password}" | base64 --decode)
REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h $NODE_IP -p $NODE_PORT 