#!/bin/bash

source .env

ku() {
    kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} $@
}

apply() {
    envsubst < $@ | ku apply -f -
}

if [ "$1" == "bootstrap" ]; then
    apply bootstrap/network/ingress.yaml
    apply bootstrap/network/egress.yaml
    apply bootstrap/network/app.yaml
fi


if [ "$1" == "elastic" ]; then
    apply elk/elastic-statefull-set.yaml
    apply elk/headless-service.yaml
    apply elk/kibana.yaml
fi

if [ "$1" == "app" ]; then
    apply app/deployment.yaml
fi

if [ "$1" == "open" ]; then
    apply open-web-ui/base/ollama-service.yaml
    apply open-web-ui/base/ollama-statefulset.yaml
    apply open-web-ui/base/webui-deployment.yaml
    apply open-web-ui/base/webui-pvc.yaml
    apply open-web-ui/base/webui-service.yaml
fi

if [ "$1" == "translate" ]; then
    apply translate/secret.yaml
    apply translate/deployment.yaml
fi