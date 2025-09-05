# App

## Setup

```bash

docker build -t $APP_IMAGE_NAME .
docker tag $APP_IMAGE_NAME:latest $HARBOR_URL/$HARBOR_PROJECT/$APP_IMAGE_NAME:latest
docker push $HARBOR_URL/$HARBOR_PROJECT/$APP_IMAGE_NAME:latest

docker run -p 8000:80 $APP_IMAGE_NAME


```