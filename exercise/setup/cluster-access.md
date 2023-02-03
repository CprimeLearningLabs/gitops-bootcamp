# Accessing a cluster

Now that we've created clusers, let's interact with them.

## Verify kubectl is installed

You should have already set up your workstation for these labs. If you have, you have already verified kubectl in in place. To make certain, issue:

``` sh
kubectl version --short
```

You should see version numbers for the client, server, and Kustomize. For example, the output should look something like this:

```
Client Version: v1.25.0
Kustomize Version: v4.5.7
Server Version: v1.25.0
```

## See kubectl's available commands

To introduce yourself to kubectl, ask it to list the help it has available.

``` sh
kubectl --help
```

You should see output that looks something like

```
kubectl controls the Kubernetes cluster manager.

 Find more information at: https://kubernetes.io/docs/reference/kubectl/

Basic Commands (Beginner):
  create          Create a resource from a file or from stdin
  expose          Take a replication controller, service, deployment or pod and expose it as a new Kubernetes service
  run             Run a particular image on the cluster
  set             Set specific features on objects

Basic Commands (Intermediate):
  explain         Get documentation for a resource
  get             Display one or many resources
  edit            Edit a resource on the server
  delete          Delete resources by file names, stdin, resources and names, or by resources and label selector

Deploy Commands:
  rollout         Manage the rollout of a resource
  scale           Set a new size for a deployment, replica set, or replication controller
  autoscale       Auto-scale a deployment, replica set, stateful set, or replication controller

Cluster Management Commands:
  certificate     Modify certificate resources.
  cluster-info    Display cluster information
  top             Display resource (CPU/memory) usage
  cordon          Mark node as unschedulable
  uncordon        Mark node as schedulable
  drain           Drain node in preparation for maintenance
  taint           Update the taints on one or more nodes

Troubleshooting and Debugging Commands:
  describe        Show details of a specific resource or group of resources
  logs            Print the logs for a container in a pod
  attach          Attach to a running container
  exec            Execute a command in a container
  port-forward    Forward one or more local ports to a pod
  proxy           Run a proxy to the Kubernetes API server
  cp              Copy files and directories to and from containers
  auth            Inspect authorization
  debug           Create debugging sessions for troubleshooting workloads and nodes

Advanced Commands:
  diff            Diff the live version against a would-be applied version
  apply           Apply a configuration to a resource by file name or stdin
  patch           Update fields of a resource
  replace         Replace a resource by file name or stdin
  wait            Experimental: Wait for a specific condition on one or many resources
  kustomize       Build a kustomization target from a directory or URL.

Settings Commands:
  label           Update the labels on a resource
  annotate        Update the annotations on a resource
  completion      Output shell completion code for the specified shell (bash, zsh, fish, or powershell)

Other Commands:
  alpha           Commands for features in alpha
  api-resources   Print the supported API resources on the server
  api-versions    Print the supported API versions on the server, in the form of "group/version"
  config          Modify kubeconfig files
  plugin          Provides utilities for interacting with plugins
  version         Print the client and server version information

Usage:
  kubectl [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
```

This helpful bit of text will be there if you need it. Also, note that second to last line - not only can you get help for listing the available commands, but you can also get help for any of those commands. For example, try

``` sh
kubectl apply --help
```

You'll see a helpful reference for the `apply` command.

```
Apply a configuration to a resource by file name or stdin. The resource name must be specified. This resource will be
created if it doesn't exist yet. To use 'apply', always create the resource initially with either 'apply' or 'create
--save-config'.

 JSON and YAML formats are accepted.

 Alpha Disclaimer: the --prune functionality is not yet complete. Do not use unless you are aware of what the current
state is. See https://issues.k8s.io/34274.

Examples:
  # Apply the configuration in pod.json to a pod
  kubectl apply -f ./pod.json

  # Apply resources from a directory containing kustomization.yaml - e.g. dir/kustomization.yaml
  kubectl apply -k dir/

  # Apply the JSON passed into stdin to a pod
  cat pod.json | kubectl apply -f -

  # Apply the configuration from all files that end with '.json' - i.e. expand wildcard characters in file names
  kubectl apply -f '*.json'

  # Note: --prune is still in Alpha
  # Apply the configuration in manifest.yaml that matches label app=nginx and delete all other resources that are not in
the file and match label app=nginx
  kubectl apply --prune -f manifest.yaml -l app=nginx

  # Apply the configuration in manifest.yaml and delete all the other config maps that are not in the file
  kubectl apply --prune -f manifest.yaml --all --prune-whitelist=core/v1/ConfigMap

Available Commands:
  edit-last-applied   Edit latest last-applied-configuration annotations of a resource/object
  set-last-applied    Set the last-applied-configuration annotation on a live object to match the contents of a file
  view-last-applied   View the latest last-applied-configuration annotations of a resource/object

Options:
    --all=false:
        Select all resources in the namespace of the specified resource types.

    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --cascade='background':
        Must be "background", "orphan", or "foreground". Selects the deletion cascading strategy for the dependents
        (e.g. Pods created by a ReplicationController). Defaults to background.

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print the object that would be sent, without
        sending it. If server strategy, submit server-side request without persisting the resource.

    --field-manager='kubectl-client-side-apply':
        Name of the manager used to track field ownership.

    -f, --filename=[]:
        The files that contain the configurations to apply.

    --force=false:
        If true, immediately remove resources from API and bypass graceful deletion. Note that immediate deletion of
        some resources may result in inconsistency or data loss and requires confirmation.

    --force-conflicts=false:
        If true, server-side apply will force the changes against conflicts.

    --grace-period=-1:
        Period of time in seconds given to the resource to terminate gracefully. Ignored if negative. Set to 1 for
        immediate shutdown. Can only be set to 0 when --force is true (force deletion).

    -k, --kustomize='':
        Process a kustomization directory. This flag can't be used together with -f or -R.

    --openapi-patch=true:
        If true, use openapi to calculate diff when the openapi presents and the resource can be found in the openapi
        spec. Otherwise, fall back to use baked-in types.

    -o, --output='':
        Output format. One of: (json, yaml, name, go-template, go-template-file, template, templatefile, jsonpath,
        jsonpath-as-json, jsonpath-file).

    --overwrite=true:
        Automatically resolve conflicts between the modified and live configuration by using values from the modified
        configuration

    --prune=false:
        Automatically delete resource objects, that do not appear in the configs and are created by either apply or
        create --save-config. Should be used with either -l or --all.

    --prune-whitelist=[]:
        Overwrite the default whitelist with <group/version/kind> for --prune

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests
        organized within the same directory.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matching
        objects must satisfy all of the specified label constraints.

    --server-side=false:
        If true, apply runs in the server instead of the client.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    --timeout=0s:
        The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the
        object

    --validate='strict':
        Must be one of: strict (or true), warn, ignore (or false).              "true" or "strict" will use a schema to validate
        the input and fail the request if invalid. It will perform server side validation if ServerSideFieldValidation
        is enabled on the api-server, but will fall back to less reliable client-side validation if not.                "warn" will
        warn about unknown or duplicate fields without blocking the request if server-side field validation is enabled
        on the API server, and behave as "ignore" otherwise.            "false" or "ignore" will not perform any schema
        validation, silently dropping any unknown or duplicate fields.

    --wait=false:
        If true, wait for resources to be gone before returning. This waits for finalizers.

Usage:
  kubectl apply (-f FILENAME | -k DIRECTORY) [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands)
```

### Query contexts

We'll start using kubectl by having it share some configuration information about cluster contexts it knows about.

``` sh
kubectl config get-contexts
```

This should show, at the very least, contexts for connecting to the two clusters we created in the prior lab (named `kind-kind` and `kind-second` - note the kind convention that the context shows with a name for the cluster prefixing it with `kind-`).

If you have enabled the Kubernetes cluster feature that comes with Docker Desktop, you'll likely also see a context for that. If you've already been using your machine for interacting with Kubernetes clusters, you'll likely already have some other contexts for connecting to other clusters. These other clusters are likely remote clusters, perhaps in a public cloud offered by a provider.

The output will look something like this

```
CURRENT   NAME                     CLUSTER                  AUTHINFO                 NAMESPACE
          docker-desktop           docker-desktop           docker-desktop
          kind-kind                kind-kind                kind-kind
*         kind-second              kind-second              kind-second
```

This tells us that your local kubeconfig contains more than one context to enable connecting to more than one cluster, or at least one cluster in more than one way (like using different default namespaces).

Note that one of your contexts will be marked as current. If you followed the steps in the prior lab and came directly to this one, you should have the `kind-second` cluster set as current. This is because when kind creates a local clsuter for you, it sets up a context in your kubeconfig and sets it as current.

You can switch which context is current with

```
kubectl config use-context <desired context name>
```

Try this by switching to the first kind cluster we created with

```
kubectl config use-context kind-kind
```

Running `kubectl config get-contexts` again will now show that `kind-kind` is the current context.

The meaning of the current context is that when you issue commands with kubectl, kubectl will send API requests to the cluster specified by that context. So by saving contexts for different clusters and different cluster configurations, we're enabling easy switching between working with different clusters by setting the current context to the one we desire in the moment.

## Viewing resources in a cluster

Now that we've gotten a taste of issuing commands with kubectl and an introduction to contexts for knowing what cluster we're dealing with, let's actually interact with a cluster.

You should be set up with a context pointing to your own local cluster, running with nodes that are Docker containers on your machine, with a cluster and context named `kind-kind`. This is a cluster without mauch going on, as we've only recently created it and haven't done much else.

kubectl requires a command. Generally, for a read-only view of resources, the `get` command is one you'll use frequently.

Let's first just see what namespaces exist in the clsuter. Namespaces, in Kubernetes give a level of isolation for resources to exist with scopes for names and the abilty to apply access rules only in given scopes.

```
kubectl get namespaces
```

The output should show you a list of namespaces. It should look something like

```
NAME                 STATUS   AGE
default              Active   38d
kube-node-lease      Active   38d
kube-public          Active   38d
kube-system          Active   38d
local-path-storage   Active   38d
```

The namespaces you see are a set of defaults that have resources providing services to the cluster for general operation.

In a basic cluster without much embelishment there will be a numder of pods running in these namespaces. A pod is the atom of operation of containerized workloads in a cluster. A pod consists of one or more containers. You can see all of the pods in all of the namespaces in the whole cluster with

```
kubectl get pods --all-namespaces
```

This will give you a picture of what is already running in a cluster before you take any action.

## Create a pod just to see it running

kubectl enables not only viewing resources, but creating them as well.

We can create a pod of our own. For this purpose, Kubernetes has `create` and `run` commands.

First, let's create a new namespaces into which we'll insert our new pod.

```
kubectl create namespaces first-pod
```

Then, we'll create a pod in this namespace

```
k run first-pod --image nginx -n first-pod
```

We've now created a pod. We know this to be true because kubectl told us it created the pod

```
pod/first-pod created
```

and because we can see that it exists by listing the pods in the `first-pod` namespace with

```
kubectl get pod -n first-pod
```

If you've not already pulled the `nginx` image to your machine, it may take several seconds (maybe even close to a minute) before the pod is fully created (this is because the image gets downloaded from a registry if it's not already on the machine). The pod will show a status of `ContainerCreating` until it finally shows up as `Running`.

```
NAME            READY   STATUS    RESTARTS   AGE
pod/first-pod   1/1     Running   0          35s
```

We used `nginx` here because it's an image that runs a webserver. For this purpose of creating a pod that stays alive, we need to do something to make sure there's a process running in the container such that it remains running  and there container, therefore, remains running. Usinga  webserver like nginx suits this purpose.
