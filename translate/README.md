# Translate App

## Setup

```bash

export TRANSLATE_IMAGE_NAME=translation-app

docker build -t $TRANSLATE_IMAGE_NAME ./translate/
docker tag $TRANSLATE_IMAGE_NAME:latest $HARBOR_URL/$HARBOR_PROJECT/$TRANSLATE_IMAGE_NAME:latest
docker push $HARBOR_URL/$HARBOR_PROJECT/$TRANSLATE_IMAGE_NAME:latest

```


```bash

export TRANSLATION_IP=10.200.32.97
curl -X POST -H "Content-Type: application/json" -d '{"text": "Hello, world!", "target_language": "es"}' http://${TRANSLATION_IP}/translate

curl -X POST -H "Content-Type: application/json" -d '{"text": "Hello, world\\!", "target\_language": "es"}' http://0.0.0.0:8080/translate

```