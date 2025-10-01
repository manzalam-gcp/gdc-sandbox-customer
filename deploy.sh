#!/bin/bash

source .env
source functions.sh

ACTION=${1:-apply}
COMPONENT=$2

if [ "$ACTION" != "apply" ] && [ "$ACTION" != "delete" ] && [ "$ACTION" != "restart" ]; then
    COMPONENT=$1
    ACTION="apply"
fi

if [ -z "$COMPONENT" ]; then
    echo "Usage: $0 [apply|delete|restart] {bootstrap|elastic|app|open|translate|video}"
    exit 1
fi

case "$COMPONENT" in
    bootstrap)
        $ACTION bootstrap/2-iam/
        $ACTION bootstrap/3-network/
        $ACTION bootstrap/5-platform/ platform
        ;;
    elastic)
        $ACTION workloads/elastic/base/
        ;;
    app)
        $ACTION workloads/app/base/
        ;;
    open)
        $ACTION workloads/open/base/
        ;;
    translate)
        $ACTION workloads/translate/base/
        ;;
    video)
        $ACTION workloads/video/base/
        ;;
    *)
        echo "Error: Unknown component '$COMPONENT'."
        echo "Usage: $0 [apply|delete|restart] {bootstrap|elastic|app|open|translate}"
        exit 1
        ;;
esac