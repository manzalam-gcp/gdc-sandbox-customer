#!/bin/bash


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
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=project-vm-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=project-vm-image-admin --member=user:$PLATFORM_ADMIN
gdcloud projects add-iam-policy-binding $WORKLOAD_PROJECT --role=ai-platform-admin --member=user:$PLATFORM_ADMIN
