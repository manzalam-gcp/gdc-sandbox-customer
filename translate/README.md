# Translate App

## Setup

```bash

export TRANSLATE_IMAGE_NAME=translation-app

docker build -t $APP_IMAGE_NAME .
docker tag $APP_IMAGE_NAME:latest $HARBOR_URL/$HARBOR_PROJECT/$APP_IMAGE_NAME:latest
docker push $HARBOR_URL/$HARBOR_PROJECT/$APP_IMAGE_NAME:latest



```
