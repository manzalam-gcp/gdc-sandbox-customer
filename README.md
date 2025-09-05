# GDC Sandbox

### .env file

```bash

SANDBOX_INSTANCE=""
SANDBOX_ZONE=us-central1-c
SANDBOX_PROJECT=""
SANDBOX_LOCAL_PORT_NUMBER=8888
SANDBOX_USER=""

PLATFORM_ADMIN="fop-platform-admin@example.com"

HARBOR_USERNAME=''
HARBOR_PASSWORD=''
HARBOR_URL='user-haas-instance-user-project.org-1.zone1.google.gdch.test'
HARBOR_URL_HTTPS="https://${HARBOR_URL}"
HARBOR_SECRET=harbor-secret
HARBOR_PROJECT=''

WORKLOAD_PROJECT='' 
NAMESPACE=${WORKLOAD_PROJECT}

IMAGE_NAME=web-server-test
KUBECONFIG=${HOME}/user-vm-1-kubeconfig 

export HARBOR_URL
export HARBOR_PROJECT
export HARBOR_SECRET

alias ku="kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE}"


```