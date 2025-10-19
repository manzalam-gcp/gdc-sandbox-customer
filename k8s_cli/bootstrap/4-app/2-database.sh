#!/bin/bash

source .env

gdcloud database clusters create $DB_ALLOY_CLUSTER_NAME --database-version $DB_VERSION --admin-password $DB_ADMIN_PASSWORD --project $WORKLOAD_PROJECT

gdcloud database clusters create $DB_PSQL_CLUSTER_NAME --database-version POSTGRESQL_13 --admin-password $DB_ADMIN_PASSWORD --project $WORKLOAD_PROJECT

