# Blue/Green deployment

Using Kubernetes deployment resources for instructing Kubernetes on how to construct and operate the containerized workloads of our systems is good and intuitive.

We often want more, though. The Argo project has other offerings, in addition to ArgoCD. Argo rollouts creates custom resource definitions in you cluster to offer additional deployment capabilities. This lab will demonstrate using the Blue/Green deployment strategy of Argo rollouts to address some additional deployment considerations.

## Setup

### Install Argo Rollouts

To use Argo rollouts, you'll first need to add it to your cluster. This can be done by applying a manifest or by installing a Helm chart. We'll use Helm here and install it to both of the clusters we're using in a new namespace. You have already added the Argo project's Helm repository, so there's no need to do that again. All it takes to get set up in both clusters is this:

```
kubectl config use-context kind-gitops-development
kubectl create namespace argorollouts
helm upgrade --install argorollouts argo/argo-rollouts -n argorollouts
kubectl config use-context kind-gitops-production
kubectl create namespace argorollouts
helm upgrade --install argorollouts argo/argo-rollouts -n argorollouts
```

### Verfiy install the argo-rollouts plugin for kubectl

Argo Rollouts has a plugin for kubectl and you should have installed it earlier in the setup.

You can check that it's installed with

```
kubectl argo rollouts --help
```

The output should look as follows and it should return a 0 exit code.

```
This command consists of multiple subcommands which can be used to manage Argo Rollouts.

Usage:
  kubectl-argo-rollouts COMMAND [flags]
  kubectl-argo-rollouts [command]

Examples:
  # Get guestbook rollout and watch progress
  kubectl argo rollouts get rollout guestbook -w

  # Pause the guestbook rollout
  kubectl argo rollouts pause guestbook

  # Promote the guestbook rollout
  kubectl argo rollouts promote guestbook

  # Abort the guestbook rollout
  kubectl argo rollouts abort guestbook

  # Retry the guestbook rollout
  kubectl argo rollouts retry guestbook

Available Commands:
  abort         Abort a rollout
  completion    Generate completion script
  create        Create a Rollout, Experiment, AnalysisTemplate, ClusterAnalysisTemplate, or AnalysisRun resource
  dashboard     Start UI dashboard
  get           Get details about rollouts and experiments
  help          Help about any command
  lint          Lint and validate a Rollout
  list          List rollouts or experiments
  notifications Set of CLI commands that helps manage notifications settings
  pause         Pause a rollout
  promote       Promote a rollout
  restart       Restart the pods of a rollout
  retry         Retry a rollout or experiment
  set           Update various values on resources
  status        Show the status of a rollout
  terminate     Terminate an AnalysisRun or Experiment
  undo          Undo a rollout
  version       Print version

Flags:
      --as string                      Username to impersonate for the operation. User could be a regular user or a service account in a namespace.
      --as-group stringArray           Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid string                  UID to impersonate for the operation.
      --cache-dir string               Default cache directory (default "/home/user/.kube/cache")
      --certificate-authority string   Path to a cert file for the certificate authority
      --client-certificate string      Path to a client certificate file for TLS
      --client-key string              Path to a client key file for TLS
      --cluster string                 The name of the kubeconfig cluster to use
      --context string                 The name of the kubeconfig context to use
  -h, --help                           help for kubectl-argo-rollouts
      --insecure-skip-tls-verify       If true, the server's certificate will not be checked for validity. This will make your HTTPS connections insecure
  -v, --kloglevel int                  Log level for kubernetes client library
      --kubeconfig string              Path to the kubeconfig file to use for CLI requests.
      --loglevel string                Log level for kubectl argo rollouts (default "info")
  -n, --namespace string               If present, the namespace scope for this CLI request
      --request-timeout string         The length of time to wait before giving up on a single server request. Non-zero values should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don't timeout requests. (default "0")
  -s, --server string                  The address and port of the Kubernetes API server
      --tls-server-name string         Server name to use for server certificate validation. If it is not provided, the hostname used to contact the server is used
      --token string                   Bearer token for authentication to the API server
      --user string                    The name of the kubeconfig user to use

Use "kubectl-argo-rollouts [command] --help" for more information about a command.
```

## Copy existing deployment to make a Blue/Green Rollout

Go now to your infrastructure repository and checkout the `development` branch. 

```
git checkout development
```

First, we'll create a copy of our existing deployment at `yaml-manifests/simple-http-server-deployment.yaml`.

In a POSIX compliant shell (like bash or zsh), that looks like

``` sh
cp yaml-manifests/simple-http-server-deployment.yaml yaml-manifests/simple-http-server-rollout.yaml
```

In Powershell use

``` powershell
Copy-Item yaml-manifests\simple-http-server-deployment.yaml yaml-manifests\simple-http-server-rollout.yaml
```

In the new file, `yaml-manifests\simple-http-server-rollout.yaml`, change the `apiVersion` element at the root of the file from `apiVersion: apps/v1` to `apiVersion: argoproj.io/v1alpha1` and the `kind` element at the root of the file from `kind: Deployment` to `kind: Rollout`. Change the app labels from `simple-http-server` to `simple-http-server-for-rollout`.

Add a strategy element as a child of `spec` with this content:

``` yaml
  strategy:
    blueGreen: 
      activeService: simple-http-server-service
      previewService: simple-http-server-service-preview
      autoPromotionEnabled: false
```

The result should look like this:

``` yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: simple-http-server-rollout
spec:
  replicas: 3
  selector:
    matchLabels:
      app: simple-http-server-for-rollout
  template:
    metadata:
      labels:
        app: simple-http-server-for-rollout
    spec:
      containers:
      - name: simple-http-server-for-rollout
        image: ghcr.io/<GitHub organization>/simple-http-server:<tag of your latest version>
        ports:
        - containerPort: 8080
  strategy:
    blueGreen: 
      activeService: simple-http-server-rollout-service
      previewService: simple-http-server-rollout-service-preview
      autoPromotionEnabled: false
```

Also, make a two new service manifests. You can do this by copying the existing one twice and modifying it.

In a POSIX compliant shell (like bash or zsh), that looks like

``` sh
cp yaml-manifests/simple-http-server-service.yaml yaml-manifests/simple-http-server-rollout-service.yaml
cp yaml-manifests/simple-http-server-service.yaml yaml-manifests/simple-http-server-rollout-service-preview.yaml
```

In Powershell use

``` powershell
Copy-Item yaml-manifests\simple-http-server-service.yaml yaml-manifests\simple-http-server-rollout-service.yaml
Copy-Item yaml-manifests\simple-http-server-service.yaml yaml-manifests\simple-http-server-rollout-service-preview.yaml
```
In both new files, change the app property for the selector from `simple-http-server` to `simple-http-server-for-rollout`.

In the `yaml-manifests/simple-http-server-rollout-service.yaml` Change the `metadata.name` element to `name: simple-http-server-rollout-service`

In the `yaml-manifests/simple-http-server-rollout-service-preview.yaml` Change the `metadata.name` element to `name: simple-http-server-rollout-service-preview`

The content of `yaml-manifests/simple-http-server-rollout-service.yaml` should now look like this:

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: simple-http-server-rollout-service
spec:
  selector:
    app: simple-http-server-for-rollout
  ports:
  - name: http
    port: 80
    targetPort: 8080
  type: ClusterIP
```

The content of `yaml-manifests/simple-http-server-rollout-service-preview.yaml` should now look like this:

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: simple-http-server-rollout-service-preview
spec:
  selector:
    app: simple-http-server-for-rollout
  ports:
  - name: http
    port: 80
    targetPort: 8080
  type: ClusterIP
```

Additionally, create another ingress by copying the existing one and modifying the copy.

In a POSIX compliant shell (like bash or zsh), that looks like

``` sh
cp yaml-manifests/simple-http-server-ingress.yaml yaml-manifests/simple-http-server-rollout-ingress.yaml
```

In Powershell use

``` powershell
Copy-Item yaml-manifests\simple-http-server-ingress.yaml yaml-manifests\simple-http-server-rollout-ingress.yaml
```

Change the paths and names in the copy so it looks like

``` yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-http-server-rollout-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  rules:
    - http:
        paths:
          - path: /rollout-simple-http-server/(.*)
            pathType: Prefix
            backend:
              service:
                name: simple-http-server-rollout-service
                port:
                  number: 80
          - path: /rollout-simple-http-server
            pathType: Prefix
            backend:
              service:
                name: simple-http-server-rollout-service
                port:
                  number: 80
```

Commit and push the changes to the deployment manifest and the new service manifest. Wait for ArgoCd to sync or click the `Refresh` button.

### Roll out an update

After the application synchronizaes, we'll make a change to the application to see it update with a blue/green rollout.

Go to your application repository and add a new path on which to respond with something different. For example, make the application repond to the path `/friend` with `Hello, friend!`.

This will make your `main.go` look like

``` Go
package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, GitOps!")
    })
    http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, User!")
    })
    http.HandleFunc("/friend", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, Friend!")
    })

    http.ListenAndServe(":8080", nil)
}
```

When you commit and push this, your GitHub Action will create a new version of your application image. Get the tag for this version and put it commit it to the `development` branch of your infrastructure repository.

Push the update and use the following command to see the status of the rollout and watch as it updates.

```
kubectl argo rollouts get rollout simple-http-server-rollout -n simple-http-server-argo-declarative --watch
```

This will show you a view of the replicaset that servers your application and a new one it will create as the preview version.

Because we configured the rollout not to automatically provision, the new version of the application won't go live until you promote it.

For the moment, if you request the `/friend` path, you'll still see the old version (showing the default `Hello GitOps!` message).

Try opening a new terminal window (because your current one is occupied with watching the rollout) and there issue the following command and close the terminal window (to return to the one watching thte rollout).

```
kubectl argo rollouts promote simple-http-server-rollout -n simple-http-server-argo-declarative
```

You should see the preview replicaset become stable and active. Eventually, the old replicaset will scale down.
