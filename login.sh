#!/bin/bash 

source .env

gdcloud auth login --login-config-cert=$HOME/org-1-web-tls-ca.cert
gdcloud clusters get-credentials ${CLUSTER_NAME} --zone zone1 --kubeconfig=${KUBECONFIG}
echo $HARBOR_PASSWORD | docker login $HARBOR_URL_HTTPS -u $HARBOR_USERNAME --password-stdin
