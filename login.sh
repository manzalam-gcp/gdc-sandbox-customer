#!/bin/bash 

source .env

gdcloud auth login --login-config-cert=/tmp/org-1-web-tls-ca.cert
gdcloud clusters get-credentials user-vm-1 --zone zone1
echo $HARBOR_PASSWORD | docker login $HARBOR_URL_HTTPS -u $HARBOR_USERNAME --password-stdin
