#!/bin/bash

source .env
source functions.sh

if [ "$1" == "app" ]; then
    docker_build "./app/" "web-server-test"
fi

if [ "$1" == "translate" ]; then
    docker_build "./translate/"
fi

if [ "$1" == "open" ]; then
    docker_build "./open/ollama/" "ollama"
    docker_pull "ghcr.io/open-webui/open-webui:main" "open-webui"
fi

if [ "$1" == "elastic" ]; then
    docker_pull "elasticsearch:8.11.4" "elasticsearch"
    docker_pull "kibana:8.11.4" "kibana"
    docker_pull "busybox:latest" "busybox"
fi
