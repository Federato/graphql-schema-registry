#!/bin/bash

HELM_VERSION=3.1.1
HELM_GCS_VERSION=0.3.1


echo "Installing Helm..."
wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
tar -zxf helm-v${HELM_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version


echo "Install GCS Plugin"
helm plugin install https://github.com/hayorov/helm-gcs.git
helm plugin update gcs

helm repo add federato gs://federato-helm-charts


