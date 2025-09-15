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
    apply elastic/base/
fi

if [ "$1" == "app" ]; then
    apply app/deployment.yaml
fi

if [ "$1" == "open" ]; then
    apply open-web-ui/base/
fi

if [ "$1" == "translate" ]; then
    apply translate/secret.yaml
    apply translate/deployment.yaml
fi