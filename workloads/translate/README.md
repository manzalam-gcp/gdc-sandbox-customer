# Translate App

## Setup

```bash

```


```bash

export TRANSLATION_IP=10.200.32.97
curl -X POST -H "Content-Type: application/json" -d '{"text": "Hello, world!", "target_language": "es"}' http://${TRANSLATION_IP}/translate

curl -X POST -H "Content-Type: application/json" -d '{"text": "Hello, world\\!", "target\_language": "es"}' http://0.0.0.0:8080/translate

```