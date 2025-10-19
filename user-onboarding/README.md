1. Set up .env and `source .env` 

1. In CLI, login in as custom user: `login` and Log in to console as custom user.  Harbor login will fail. 

1.  Create harbor project
```
gdcloud harbor harbor-projects create ${HARBOR_PROJECT} \
--instance ${HARBOR_INSTANCE} \
--project ${HARBOR_INSTANCE_PROJECT}
```

1. Log in to console as custom user. You will need to create a Harbor service account manually. Go to harbor, switch to `user-project`. Go to project in harbor. create robot account.  adjust .env.   This will be used for `docker login` in the `login` script.   Re-run `login` to confirm login to repo. 

1. Add harbor secret to cluster

```
ku create secret docker-registry ${HARBOR_SECRET} --from-file=.dockerconfigjson=$HOME/.docker/config.json
```

1. Configure set up to ADO. 







