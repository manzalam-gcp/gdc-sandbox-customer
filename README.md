# GDC Sandbox


## Getting Started 

### Pre-requisites

1. Cloudtop: You will need a Cloudtop environment to access urls on Sandbox public network. You can also use this to RDP into sandbox.

2. gLinux: Set up gLinux on laptop. 

3. Remmina: [Install Remmina](https://remmina.org/how-to-install-remmina/#ubuntu) for RDP access to Sandbox. 

4. Review [GDC Sandbox Devleoper Guide](https://services.google.com/fh/files/misc/gdc_sandbox_developer_guide.pdf): This repo builds on the fundamentials and helps you get set up.  NB. Set up `gdcloud`. 

5. Gitlab account. 


### .env file

The scripts use environment variables to facilitate. Copy `.env.sample` to `.env` and edit as needed. Certain variables will get added as you go. Run `source .env` to instantiate the variables. 


```bash
cp .env_sample .env
source .env

```

The initial `SANDBOX_*` variables are provided by the GDC Sandbox team. 


### Connection Script `sandbox.sh`

This script is a utility to help you connect to and manage files on your remote GDC Sandbox instance from your local machine. It handles creating secure tunnels for RDP or SSH access and simplifies copying files to and from the sandbox.

*   `./sandbox.sh [command]`: A utility script run from your local machine to interact with the remote sandbox VM.
    *   **Commands & Usage:**
        *   `./sandbox.sh tunnel`: Starts a Google Cloud IAP tunnel, allowing you to connect to the remote instance via RDP on a local port.
        *   `./sandbox.sh ssh`: Uses `sshuttle` and IAP to create a secure VPN-like connection to the sandbox's internal network, allowing direct access to services.
        *   `./sandbox.sh env`: Copies your local `.env` file to the project directory on the remote sandbox.
        *   `./sandbox.sh up <local_path>`: Recursively copies a local directory to the workspace on the remote sandbox.
        *   `./sandbox.sh cp <remote_path>`: Copies a file from the remote sandbox to your local machine.


## Setting up GDC Sandbox

### Set up gdcloud

Login to console. Click "Download CLI bundle". 

```
cd ~
mv Downloads/gdcloud_cli.tar.gz .
tar -xf gdcloud_cli.tar.gz
echo 'export PATH=$PATH:~/google-distributed-cloud-hosted-cli/bin' >> ~/.bashrc
source ~/.bashrc 
gdcloud config set core/organization_console_url https://console.org-1.zone1.google.gdch.test


```

### Set up gitlab account

Generate a keypaid on GDC CLI. Run `ssh-keygen`.  Move key into `~/.ssh/gitlab.pem`. Copy public key to gitlab ssh keys. 

Carete `~/.ssh/config` including:

```
Host gitlab
    HostName gitlab.com
    User git
    PreferredAuthentications publickey
    IdentitiesOnly yes
    HostkeyAlgorithms +ssh-rsa
    IdentityFile ~/.ssh/gitlab.pem 
```

Clone this repo: `git clone gitlab:/google-cloud-ce/communities/Canada-PubSec/gdc/gdc-sandbox`.



### Set up certs

These certs are needed for login and for service accounts.  

```bash
cd ~

echo -n | openssl s_client -showcerts -connect console.org-1.zone1.google.gdch.test:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > org-1-web-tls-ca.cert

curl -k https://console.org-1.zone1.google.gdch.test/.well-known/login-config | grep certificateAuthorityData | head -1 | cut -d : -f 2 | awk '{print $1}' | sed 's/"//g' | base64 --decode > trusted_certs.crt
```


### GDC Sandbox Scripts

This project includes a set of utility scripts to streamline common development tasks on the GDC Sandbox. These scripts handle authentication, building container images, and deploying applications to the Kubernetes cluster, automating repetitive and complex command sequences.

* `./login.sh` (alias: `login`): This script automates the login process for the development environment. It performs the following actions:
  * Sources the .env file to load necessary environment variables.
  * Authenticates with Google Distributed Cloud (GDC) using `gdcloud auth login`.
  * Retrieves Kubernetes credentials for the `user-vm-1` (env var `CLUSTER_NAME`) cluster, configuring `kubectl`.
  * Logs into the Harbor container registry using Docker, enabling you to pull and push images.

* `./deploy.sh [action] [component]` (alias: `deploy`): This script applies or deletes application configurations on the Kubernetes cluster. It uses functions that wrap `kubectl apply -k` and `kubectl delete -k` and `kubectl rollout restart -k`.
  * **`action`** (optional): `apply` (default) or `delete` or `restart`.
  * **`component`**: The component to manage. Available components are `bootstrap`, `elastic`, `app`, `open`, `translate`.
  * **Usage:**
    *   `./deploy.sh elastic` or `./deploy.sh apply elastic` - Applies the `elastic` component manifests.
    *   `./deploy.sh delete elastic` - Deletes the `elastic` component resources.
    *   `./deploy.sh restart elastic` - Restarts the `elastic` component resources.

* `./build.sh [component]` (alias: `build`): This script builds local container images or pulls public ones, and then pushes them to the private Harbor registry. This is a necessary step before deploying applications, as it makes the images accessible to the Kubernetes cluster.
  * **Usage:** `build <component_name>`
  * **Available components:** `app`, `translate`, `open`, `elastic`.
  * **Actions:**
    *   For `app` and `translate`, it builds a Docker image from the source code in their respective directories.
    *   For `open` and `elastic`, it pulls the required public images from their official registries.

## Bootstrap

The bootstrap process prepares the GDC Sandbox environment for application deployment. It involves a sequence of one-time setup scripts that create the necessary infrastructure and permissions. This includes setting up the primary workload project, configuring IAM roles for administrative access, and establishing baseline network policies for the Kubernetes cluster. These steps must be completed before deploying any applications.


## `1-project`

The `1-project.sh` step createst the main workload project.  Set `WORKLOAD_PROJECT` as the main workload project name. 

This script uses a shared Harbor instance.  These are likely as follows: 

```
HARBOR_INSTANCE=user-haas-instance
HARBOR_INSTANCE_PROJECT=user-project
```

NB. You will need to create a Harbor service account manually.  This will be used for `docker login` in the `login` script. 

Set environment variables as follows:

```
HARBOR_PASSWORD=your-password
HARBOR_USERNAME=your-username
```

The `2-database.sh` script is optional. This creates an AlloyDB instance and a PostgreSQL instance

### Run

```bash
./bootstrap/1-project/1-project.sh
./bootstrap/1-project/2-database.sh
```

## `2-iam`

This step configures the necessary roles for the main platform admin user `PLATFORM_ADMIN="fop-platform-admin@example.com"`. 

The roles added include all application devlopment roles. 

### Run

```bash
./bootstrap/2-iam/1-roles.sh
./bootstrap/2-iam/2-service-accounts.sh
```

## `3-network`

This step configures wide-open ingress and egress to the k8s network.  This is configured for testing.

### Run

```bash
deploy bootstrap
```


## Testing and Debugging

### Test web service

1. Get list of services: `ku get services`

```
sandboxuser2@bootstrapper-zone1:~/Workspace/gdc-sandbox$ ku get services
NAME                                                              TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)             AGE
elasticsearch                                                     ClusterIP      None           <none>          9200/TCP,9300/TCP   10d
elasticsearch-service                                             LoadBalancer   10.252.7.214   10.200.32.100   9200:32109/TCP      5d
g-svc-g-fre-elasticsearch-service-user-vm-1-e48-extern-3d8e441f   ClusterIP      None           <none>          9200/TCP            5d
g-svc-g-fre-kibana-svc-user-vm-1-6f373458-external-3da7fa31       ClusterIP      None           <none>          80/TCP              10d
g-svc-g-fre-ollama-service-user-vm-1-0812b24f-external-90dd6430   ClusterIP      None           <none>          11434/TCP           5d2h
g-svc-g-fre-ollama-user-vm-1-2f4013c5-external-865f8c34           ClusterIP      None           <none>          11434/TCP           17h
g-svc-g-fre-open-webui-service-user-vm-1-9245f-externa-71fb03f0   ClusterIP      None           <none>          80/TCP              10d
g-svc-g-fre-translation-app-service-user-vm-1-6-extern-4281d8b2   ClusterIP      None           <none>          80/TCP              6d23h
g-svc-g-fre-web-server-test-service-user-vm-1-6-extern-550e41d5   ClusterIP      None           <none>          80/TCP              70m
kibana-svc                                                        LoadBalancer   10.252.6.175   10.200.32.81    80:31694/TCP        10d
ollama                                                            LoadBalancer   10.252.7.131   10.200.32.101   11434:30377/TCP     17h
ollama-service                                                    LoadBalancer   10.252.7.121   10.200.32.99    11434:31045/TCP     10d
open-webui-service                                                LoadBalancer   10.252.7.1     10.200.32.91    80:32207/TCP        10d
translation-app-service                                           LoadBalancer   10.252.7.215   10.200.32.97    80:31494/TCP        6d23h
web-server-test-service                                           LoadBalancer   10.252.7.128   10.200.32.74    80:30855/TCP        70m
```


2. Create SSH tunnel in a new terminal window: `./sandbox.sh ssh`

3. Get external ip of `web-server-test-service`.  Then run: `curl 10.200.32.74`. 

```
tackaberry@tackaberry50:~/Workspace/gdc-sandbox$ curl 10.200.32.74
<!DOCTYPE html>
<html>
<body>
Hello World!!
</body>
```

4. Get external ip of `translation-app-service`.  Then run: 

Based on this [tutorial](https://cloud.google.com/distributed-cloud/sandbox/latest/services/translation).

```
export IP=10.200.32.97
curl -X POST -H "Content-Type: application/json" -d '{"text": "Hello, world!", "target_language": "es"}' http://${IP}/translate
```

```
{
  "detected_source_language": "en",
  "original_text": "Hello, world!",
  "translated_text": "\u00a1Hola Mundo!"
}
```

### Log into pod to inspect

1. Get deployments: `ku get pods`

```
sandboxuser2@bootstrapper-zone1:~/Workspace/gdc-sandbox$ ku get pods
NAME                                     READY   STATUS    RESTARTS     AGE
es-cluster-0                             1/1     Running   0            3d23h
es-cluster-1                             1/1     Running   0            3d23h
es-cluster-2                             1/1     Running   0            3d23h
kibana-6c696cb7c9-gg9t7                  1/1     Running   1 (4d ago)   4d
ollama-0                                 1/1     Running   0            4d1h
open-webui-deployment-564f857845-9hf6b   1/1     Running   0            17h
translation-app-684ccb946b-646cq         1/1     Running   0            17h
web-server-test-6dfc8d8876-5l4hz         1/1     Running   0            3m6s
web-server-test-6dfc8d8876-jvqxm         1/1     Running   0            2m56s

```

2. Log into pod: `ku exec -it open-webui-deployment-564f857845-9hf6b -- /bin/bash`


## Exact Setup

```bash
cd ~
mkdir ~/.ssh
cd .ssh/
touch config
# paste in ssh config from above
vi config 
ssh-keygen -f gitlab
mv gitlab gitlab.pem
cat gitlab.pub
# copy to gitlab ssh keys
cd ..
git clone gitlab:/google-cloud-ce/communities/Canada-PubSec/gdc/gdc-sandbox

cd ~

# go to console, login download CLI bundle
mv Downloads/gdcloud_cli.tar.gz .
tar -xf gdcloud_cli.tar.gz
echo 'export PATH=$PATH:~/google-distributed-cloud-hosted-cli/bin' >> ~/.bashrc
source ~/.bashrc

gdcloud config set core/organization_console_url https://console.org-1.zone1.google.gdch.test
gdcloud components install gdcloud-k8s-auth-plugin
gdcloud components install storage-cli-dependencies

echo -n | openssl s_client -showcerts -connect console.org-1.zone1.google.gdch.test:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > org-1-web-tls-ca.cert

curl -k https://console.org-1.zone1.google.gdch.test/.well-known/login-config | grep certificateAuthorityData | head -1 | cut -d : -f 2 | awk '{print $1}' | sed 's/"//g' | base64 --decode > trusted_certs.crt


cd gdc-sandbox/

# on laptop, run `./sandbox.sh env`
source .env

login
# harbor login will fail

./bootstrap/1-project/1-project.sh

./bootstrap/2-iam/1-roles.sh 

login

# in console, attach project to user-vm-1

deploy bootstrap

build app

./bootstrap/1-project/3-harbor.sh

deploy app


```