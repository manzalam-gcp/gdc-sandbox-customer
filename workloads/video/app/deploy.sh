#!/bin/bash

source .env

IMAGE="$REPO/$SERVICE_NAME"

if echo "" | gcloud projects list &> /dev/null; then
    echo "Logged in. "
else
    echo "Not logged in"
    gcloud auth login
fi

ENV_VARS="PROJECT_ID=$PROJECT_ID,REGION=$REGION"


gcloud config set project $PROJECT_ID

gcloud builds submit --tag $IMAGE

gcloud run deploy $SERVICE_NAME \
  --image $IMAGE \
  --platform managed \
  --region $REGION \
  --set-env-vars $ENV_VARS \
  --port 80 \
  --allow-unauthenticated
  

SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region $REGION --format 'value(status.url)')
echo "Service deployed to: $SERVICE_URL"
