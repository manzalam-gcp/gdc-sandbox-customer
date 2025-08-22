source .env

gdcloud auth login --login-config-cert=/tmp/org-1-web-tls-ca.cert

curl -k https://console.org-1.zone1.google.gdch.test/.well-known/login-config | grep certificateAuthorityData | head -1 | cut -d : -f 2 | awk '{print $1}' | sed 's/"//g' | base64 --decode > trusted_certs.crt

gdcloud projects create $WORKLOAD_PROJECT

gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=ai-ocr-developer --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=ai-translation-developer --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=harbor-instance-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=harbor-instance-viewer --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=kms-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=project-iam-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=project-networkpolicy-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=secret-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=workbench-notebooks-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=k8s-networkpolicy-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=namespace-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=vertex-ai-prediction-user --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=project-grafana-viewer --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=project-db-admin --member=user:$PLATFORM_ADMIN

export SERVICE_ACCOUNT="ai-apps"
export SERVICE_ACCOUNT_KEY_FILE=serviceaccountskey.json
gdcloud iam service-accounts create $SERVICE_ACCOUNT --project $WORKLOAD_PROJECT
gdcloud iam service-accounts keys create ${SERVICE_ACCOUNT_KEY_FILE} --project ${WORKLOAD_PROJECT} --iam-account ${SERVICE_ACCOUNT} --ca-cert-path=$HOME/trusted_certs.crt
gdcloud iam service-accounts add-iam-policy-binding --project=${WORKLOAD_PROJECT} --iam-account=${SERVICE_ACCOUNT} --role=iamrole/ai-ocr-developer
gdcloud iam service-accounts add-iam-policy-binding --project=${WORKLOAD_PROJECT} --iam-account=${SERVICE_ACCOUNT} --role=iamrole/ai-translation-developer

