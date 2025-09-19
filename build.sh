#!/bin/bash

source .env
source functions.sh

case "$1" in
    app)
        docker_build "./workloads/app/" "web-server-test"
        ;;
    translate)
        docker_build "./workloads/translate/" "translate"
        ;;
    open)
        docker_build "./workloads/open/ollama/" "ollama"
        docker_pull "ghcr.io/open-webui/open-webui:main" "open-webui"
        ;;
    elastic)
        docker_pull "elasticsearch:8.11.4" "elasticsearch"
        docker_pull "kibana:8.11.4" "kibana"
        docker_pull "busybox:latest" "busybox"
        ;;
    video)
        docker_build "./workloads/video/app/" "video-intelligence"
        ;;        
    *)
        echo "Usage: $0 {app|translate|open|elastic}"
        exit 1
        ;;
esac
