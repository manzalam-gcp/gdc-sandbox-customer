source .env

gdcloud auth login --login-config-cert=/tmp/org-1-web-tls-ca.cert

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
