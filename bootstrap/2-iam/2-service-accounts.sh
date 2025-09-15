source .env

export SERVICE_ACCOUNT="ai-apps"
export SERVICE_ACCOUNT_KEY_FILE=serviceaccountskey.json

gdcloud iam service-accounts create $SERVICE_ACCOUNT --project $WORKLOAD_PROJECT
gdcloud iam service-accounts keys create ${SERVICE_ACCOUNT_KEY_FILE} --project ${WORKLOAD_PROJECT} --iam-account ${SERVICE_ACCOUNT} --ca-cert-path=$HOME/trusted_certs.crt
gdcloud iam service-accounts add-iam-policy-binding --project=${WORKLOAD_PROJECT} --iam-account=${SERVICE_ACCOUNT} --role=iamrole/ai-ocr-developer
gdcloud iam service-accounts add-iam-policy-binding --project=${WORKLOAD_PROJECT} --iam-account=${SERVICE_ACCOUNT} --role=iamrole/ai-translation-developer

