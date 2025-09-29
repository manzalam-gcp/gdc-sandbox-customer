#!/bin/bash 

source .env

gdcloud auth login --login-config-cert=$HOME/org-1-web-tls-ca.cert

KUBECONFIG=${HOME}/${CLUSTER_NAME}-kubeconfig gdcloud clusters get-credentials ${CLUSTER_NAME} --zone zone1
KUBECONFIG=${HOME}/org-1-admin-kubeconfig gdcloud clusters get-credentials org-1-admin
KUBECONFIG=${HOME}/global-api-kubeconfig gdcloud clusters get-credentials global-api

echo $HARBOR_PASSWORD | docker login $HARBOR_URL_HTTPS -u $HARBOR_USERNAME --password-stdin
