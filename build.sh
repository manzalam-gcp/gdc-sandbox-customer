#!/bin/bash

source .env

ku() {
    kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} $@
}

if [ "$1" == "translate" ]; then
    docker build -t $TRANSLATE_IMAGE_NAME ./translate/
    docker tag $TRANSLATE_IMAGE_NAME:latest $HARBOR_URL/$HARBOR_PROJECT/$TRANSLATE_IMAGE_NAME:latest
    docker push $HARBOR_URL/$HARBOR_PROJECT/$TRANSLATE_IMAGE_NAME:latest
fi

if [ "$1" == "ollama" ]; then
    export IMAGE_NAME="ollama"
    docker build -t $IMAGE_NAME ./open-web-ui/ollama/
    docker tag $IMAGE_NAME:latest $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:latest
    docker push $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:latest
fi