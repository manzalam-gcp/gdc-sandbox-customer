docker_pull() {
    docker pull $1
    docker tag $1 $HARBOR_URL/$HARBOR_PROJECT/$2:latest
    docker push $HARBOR_URL/$HARBOR_PROJECT/$2:latest
}

docker_build() {
    docker build -t $2 $1
    docker tag $2:latest $HARBOR_URL/$HARBOR_PROJECT/$2:latest
    docker push $HARBOR_URL/$HARBOR_PROJECT/$2:latest
}


ku() {
    kubectl --kubeconfig ${KUBECONFIG} $@
}

apply() {
    for f in $1/*.yaml; do envsubst < $f | ku -n ${$2 ? $2 : NAMESPACE} apply -f -; done
}

delete() {
    for f in $1/*.yaml; do envsubst < $f | ku -n ${$2 ? $2 : NAMESPACE} delete -f -; done
}

restart() {
    for f in $1/*.yaml; do envsubst < $f | ku -n ${$2 ? $2 : NAMESPACE} rollout restart -f -; done
}
