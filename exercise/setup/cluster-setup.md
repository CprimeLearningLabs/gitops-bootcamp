# Setting up a cluster

In order to do GitOps using ArgoCD, we're going to need to have a Kubernetes cluster to work with. In this lab, we'll get comfortable using the kind tool from the command line to create clusters.

## Verify kind is installed

You should have already set up your workstation for these labs. If you have, you have already verified kind in in place. To make certain, issue:

``` sh
kind version
```

You should see a version number, version for the Go language that built kind, and platform information. For example, the output should look something like this:

```
kind v0.17.0 go1.19.2 linux/amd64
```

## See kind's available commands

To introduce yourself to kind, ask it to list the help it has available.

``` sh
kind --help
```

You should see output that looks like

```
kind creates and manages local Kubernetes clusters using Docker container 'nodes'

Usage:
  kind [command]

Available Commands:
  build       Build one of [node-image]
  completion  Output shell completion code for the specified shell (bash, zsh or fish)
  create      Creates one of [cluster]
  delete      Deletes one of [cluster]
  export      Exports one of [kubeconfig, logs]
  get         Gets one of [clusters, nodes, kubeconfig]
  help        Help about any command
  load        Loads images into nodes
  version     Prints the kind CLI version

Flags:
  -h, --help              help for kind
      --loglevel string   DEPRECATED: see -v instead
  -q, --quiet             silence all stderr output
  -v, --verbosity int32   info log verbosity, higher value produces more output
      --version           version for kind

Use "kind [command] --help" for more information about a command.
```

This helpful bit of text will be there if you need it. Also, note that last line - not only can you get help for listing the available commands, but you can also get help for any of those commands. For example, try

``` sh
kind create --help
```

You'll see a helpful reference for the `create` command.

```
Creates one of local Kubernetes cluster (cluster)

Usage:
  kind create [flags]
  kind create [command]

Available Commands:
  cluster     Creates a local Kubernetes cluster

Flags:
  -h, --help   help for create

Global Flags:
      --loglevel string   DEPRECATED: see -v instead
  -q, --quiet             silence all stderr output
  -v, --verbosity int32   info log verbosity, higher value produces more output

Use "kind create [command] --help" for more information about a command.
```

### List existing clusters

We'll start using kind by having it list the clusters already running on your machine.

``` sh
kind get clusters
```

This will show what Kubernetes clusters are already running on you machine via kind. You likely have not already created any, so you'll probably see

```
No kind clusters foudn.
```

You'll see, instead, a list of clusters if you have already created one or more.

## Create a cluster with kind

Now that we've gotten a taste of issuing commands with kind, let's actually create a cluster. The simplest form of doing this looks like

```
kind create cluster
```

This will create a cluster with the default name `kind`. It takes a finite amount of time to perform this task (perhaps up to a minute or so).

You should see output that looks like

```
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.25.3) :frame_with_picture:
 ✓ Preparing nodes :package:
 ✓ Writing configuration :scroll:
 ✓ Starting control-plane :joystick:
 ✓ Installing CNI :electric_plug:
 ✓ Installing StorageClass :floppy_disk:
Set kubectl context to "kind-kind"
You can now use your cluster with:
kubectl cluster-info --context kind-kind
Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community :slightly_smiling_face:
```

You have now created a local Kubernetes cluster you can test with.

If you issue this command a second time, it will fail because a cluster with that name already exists.

## Create a cluster with kind with a nondefault name

kind will take a name parameter to let you name your cluster. We can use this parameter to create more than one cluster for our purposes.

Try this by creating a second cluster with this command

``` sh
kind create cluster --name second
```

You have now created two clusters. That's something we can work with. In the next lab, we'll start accessing clusters so we can interact with them in useful ways.
