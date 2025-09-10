# Open WebUI

## Setup

```bash

export IMAGE_NAME_PULL="ghcr.io/open-webui/open-webui:main"
export IMAGE_NAME="open-webui"
export IMAGE_VERSION="main"

docker pull $IMAGE_NAME_PULL
docker tag $IMAGE_NAME_PULL $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:$IMAGE_VERSION
docker push $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:$IMAGE_VERSION

export IMAGE_NAME_PULL="ollama/ollama:latest"
export IMAGE_NAME="ollama"
export IMAGE_VERSION="latest"

docker pull $IMAGE_NAME_PULL
docker tag $IMAGE_NAME_PULL $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:$IMAGE_VERSION
docker push $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:$IMAGE_VERSION

```

```bash

export IMAGE_NAME="ollama"
docker build -t $IMAGE_NAME ./ollama/
docker tag $IMAGE_NAME:latest $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:latest
docker push $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:latest

```





## Test 

```bash

export IMAGE_NAME="open-webui"
export IMAGE_NAME_PULL="ghcr.io/open-webui/open-webui:main"

docker pull $IMAGE_NAME_PULL

docker run -d -p 3000:8080 -v $IMAGE_NAME:/app/backend/data --name $IMAGE_NAME $IMAGE_NAME_PULL

curl http://10.200.32.99:11434/api/generate -d '{ "model": "llama3", "prompt":"Why is the sky blue?" }'

```


