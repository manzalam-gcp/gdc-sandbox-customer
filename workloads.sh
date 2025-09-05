
source .env

ku create secret docker-registry ${HARBOR_SECRET} --from-file=.dockerconfigjson=$HOME/.docker/config.json



ku get service web-server-test-service -o jsonpath='{.status.loadBalancer.ingress[*].ip}'


gdcloud database clusters create $DB_CLUSTER_NAME --database-version $DB_VERSION --admin-password $DB_ADMIN_PASSWORD --project $WORKLOAD_PROJECT

gdcloud database clusters create db-psql-tack-1 --database-version POSTGRESQL_13 --admin-password $DB_ADMIN_PASSWORD --project $WORKLOAD_PROJECT


ku get dbcluster.$DB_VERSION.dbadmin.gdc.goog $DB_CLUSTER_NAME -o=jsonpath='{.status.primary.url}'
