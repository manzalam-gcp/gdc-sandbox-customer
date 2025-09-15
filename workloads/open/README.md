# Open WebUI

## Test 

```bash

export IMAGE_NAME="open-webui"
export IMAGE_NAME_PULL="ghcr.io/open-webui/open-webui:main"

docker pull $IMAGE_NAME_PULL

docker run -d -p 3000:8080 -v $IMAGE_NAME:/app/backend/data --name $IMAGE_NAME $IMAGE_NAME_PULL

curl http://10.200.32.99:11434/api/generate -d '{ "model": "llama3", "prompt":"Why is the sky blue?" }'

```


