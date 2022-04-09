#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm pull bitnami/redis --untar --untardir ./lib/helm

# helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
# helm pull ot-helm/redis-operator --untar
# helm pull ot-helm/redis  --untar