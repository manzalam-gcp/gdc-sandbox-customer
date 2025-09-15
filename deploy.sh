#!/bin/bash

source .env
source functions.sh

if [ "$1" == "bootstrap" ]; then
    apply bootstrap/network/
fi


if [ "$1" == "elastic" || "$1" == "elastic/" ]; then
    apply elastic/base/
fi

if [ "$1" == "app" ]; then
    apply app/deployment.yaml
fi

if [ "$1" == "open" || "$1" == "open/" ]; then
    apply open/base/
fi

if [ "$1" == "translate" ]; then
    apply translate/secret.yaml
    apply translate/deployment.yaml
fi