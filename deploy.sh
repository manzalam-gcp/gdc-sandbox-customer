#!/bin/bash

source .env

ku() {
    kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} $@
}

apply() {
    envsubst < $@ | ku apply -f -
}

if [ "$1" == "elk" ]; then
    apply elk/elastic-statefull-set.yaml
    apply elk/headless-service.yaml
    apply elk/kibana.yaml
fi

if [ "$1" == "app" ]; then
    apply app/deployment.yaml
    apply app/network.yaml
fi

if [ "$1" == "open" ]; then
    apply open-web-ui/ollama-service.yaml
    apply open-web-ui/ollama-statefulset.yaml
    apply open-web-ui/deployment.yaml
    apply open-web-ui/webui-pvc.yaml
    apply open-web-ui/webui-service.yaml
fi