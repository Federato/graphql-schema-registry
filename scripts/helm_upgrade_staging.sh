#!/bin/bash

set -o errexit

HELM_VERSION=3.1.1
HELM_GCS_VERSION=0.3.1

echo "Installing Helm..."
wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
tar -zxf helm-v${HELM_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version

cd ./chart

helm upgrade --set image.tag=latest gateway-service  . --install --timeout 10m --namespace federato-apps