source .env

gdcloud projects create $WORKLOAD_PROJECT

gdcloud harbor harbor-projects create ${HARBOR_PROJECT} \
--instance ${HARBOR_INSTANCE} \
--project ${HARBOR_INSTANCE_PROJECT}


