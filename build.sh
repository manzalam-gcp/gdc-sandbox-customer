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