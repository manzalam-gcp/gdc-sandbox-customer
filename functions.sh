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
    kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} $@
}

apply() {
    for f in $1/*.yaml; do envsubst < $f | ku apply -f -; done
}

delete() {
    for f in $1/*.yaml; do envsubst < $f | ku delete -f -; done
}

restart() {
    for f in $1/*.yaml; do envsubst < $f | ku rollout restart -f -; done
}
