#!/bin/bash

export HELM_EXPERIMENTAL_OCI=1
# Login to Artifact Registry
echo "Authenticating into Google Artifact Registry"
echo ${GCLOUD_SERVICE_KEY} | helm registry login us-east4-docker.pkg.dev -u _json_key --password-stdin

echo "Packaging chart"
helm package chart

echo "Pushing chart"
helm gcs push schema-registry-service-${TAG}.tgz federato 