# GDC Sandbox


## Getting Started 

### Pre-requisites

1. Cloudtop: You will need a Cloudtop environment to access urls on Sandbox public network. You can also use this to RDP into sandbox.

2. gLinux: Set up gLinux on laptop. 

3. Remmina: [Install Remmina](https://remmina.org/how-to-install-remmina/#ubuntu) for RDP access to Sandbox. 

4. Review [GDC Sandbox Devleoper Guide](https://services.google.com/fh/files/misc/gdc_sandbox_developer_guide.pdf): This repo builds on the fundamentials and helps you get set up. 


### .env file

The scripts use environment variables to facilitate. Copy `.env.sample` to `.env` and edit as needed. Certain variables will get added as you go. Run `source .env` to instantiate the variables. 


```bash
cp .env.sample .env
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

### Set up certs

These certs are needed for login and for service accounts.  

```bash
echo -n | openssl s_client -showcerts -connect console.org-1.zone1.google.gdch.test:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > org-1-web-tls-ca.cert

curl -k https://console.org-1.zone1.google.gdch.test/.well-known/login-config | grep certificateAuthorityData | head -1 | cut -d : -f 2 | awk '{print $1}' | sed 's/"//g' | base64 --decode > trusted_certs.crt
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


### GDC Sandbox Scripts

This project includes a set of utility scripts to streamline common development tasks on the GDC Sandbox. These scripts handle authentication, building container images, and deploying applications to the Kubernetes cluster, automating repetitive and complex command sequences.

* `./login.sh` (alias: `login`): This script automates the login process for the development environment. It performs the following actions:
  * Sources the .env file to load necessary environment variables.
  * Authenticates with Google Distributed Cloud (GDC) using `gdcloud auth login`.
  * Retrieves Kubernetes credentials for the `user-vm-1` (env var `CLUSTER_NAME`) cluster, configuring `kubectl`.
  * Logs into the Harbor container registry using Docker, enabling you to pull and push images.

* `./deploy.sh [action] [component]` (alias: `deploy`): This script applies or deletes application configurations on the Kubernetes cluster. It uses functions that wrap `kubectl apply -k` and `kubectl delete -k`.
  * **`action`** (optional): `apply` (default) or `delete`.
  * **`component`**: The component to manage. Available components are `bootstrap`, `elastic`, `app`, `open`, `translate`.
  * **Usage:**
    *   `./deploy.sh elastic` or `./deploy.sh apply elastic` - Applies the `elastic` component manifests.
    *   `./deploy.sh delete elastic` - Deletes the `elastic` component resources.

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