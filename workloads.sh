
source .env


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


gdcloud database clusters create $DB_CLUSTER_NAME --database-version $DB_VERSION --admin-password $DB_ADMIN_PASSWORD --project $WORKLOAD_PROJECT

gdcloud database clusters create db-psql-tack-1 --database-version POSTGRESQL_13 --admin-password $DB_ADMIN_PASSWORD --project $WORKLOAD_PROJECT


ku get dbcluster.$DB_VERSION.dbadmin.gdc.goog $DB_CLUSTER_NAME -o=jsonpath='{.status.primary.url}'
