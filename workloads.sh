
source .env

gdcloud auth login --login-config-cert=/tmp/org-1-web-tls-ca.cert
gdcloud clusters get-credentials user-vm-1 --zone zone1
echo $HARBOR_PASSWORD | docker login $HARBOR_URL_HTTPS -u $HARBOR_USERNAME --password-stdin
alias ku="kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE}"


kubectl create secret docker-registry ${SECRET} --from-file=.dockerconfigjson=.docker/config.json -n ${NAMESPACE}

docker tag nginx ${HARBOR_URL}/${HARBOR_PROJECT}/nginx:1.25

kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} create -f nginx.yaml
kubectl get pods -l app=nginx -n ${NAMESPACE}

kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} create -f network.yaml 



docker build -t $IMAGE_NAME .

docker run -p 8000:80 $IMAGE_NAME
docker tag $IMAGE_NAME:latest $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:latest

docker push $HARBOR_URL/$HARBOR_PROJECT/$IMAGE_NAME:latest

kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} apply -f deployment.yaml 
# kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} apply -f service.yaml 
kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} create -f network.yaml 

alias ku="kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE}"
kubectl --kubeconfig=${KUBECONFIG} -n ${NAMESPACE} get service nginx-service  -o jsonpath='{.status.loadBalancer.ingress[*].ip}'
ku get svc 

ku get service web-server-test-service -o jsonpath='{.status.loadBalancer.ingress[*].ip}'

