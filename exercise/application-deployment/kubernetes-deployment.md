# Create and apply a Kubernetes deployment via manifest

The last lab left us in the context of our application repository. Now, we're going to switch to our infrastructure repository.

You should already have your infrastructure repository set up from a prior lab. We'll now want to work with that infrastructure repository. You'll want to use `cd` to move from your current directory context to where you have your clone of your infrastructure repository.

In the infrastructure repository, we want to set a few things up to be able to deploy our application to Kubernertes. Among those things are deployment to get our applicatoion up and running..

## Create a deployment manifest via YAML file

Create a subdirectory inside your infrastructure repository where we'll put the application deployment manifest. Call it `yaml-manifests`. Inside the directory, create an empty text file called `simple-http-server-deployment.yaml`.

With a POSIX compatible shell,

``` sh
mkdir yaml-manifests
touch yaml-manifests/simple-http-server-deployment.yaml
```

With PowerShell,

``` powershell
New-Item -ItemType Directory yaml-manifests
New-Item yaml-manifests/simple-http-server-deployment.yaml
```

Add the following content to your deployment YAML file (replacing `<GitHub organization>` with your GitHub organization name).

``` YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-http-server-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: simple-http-server
  template:
    metadata:
      labels:
        app: simple-http-server
    spec:
      containers:
      - name: simple-http-server
        image: ghcr.io/<GitHub organization>/simple-http-server
        ports:
        - containerPort: 8080
```

## Create a snapshot

Having added a manifest to our infrastructure repository, we'll want to make sure it's commited so we have it going forward and so it'll be there for later use in GitOps.

```
git add yaml-manifests/simple-http-server-deployment.yaml
git commit -m "Add deployment manifest for simple http server

to enable deploying the application to Kubernetes as a deployment resource"
```

Make sure to send your update to the server.

```
git push
```

## Apply the manifest

We'll use kubectl to apply this manifest to our development cluster. Later, we'll have ArgoCD do our deployments for us, but we'll just first see that we can create a deployment and get it running in our cluster.

First, make sure you're in the right context to work with your development cluster.

```
kubectl config get-contexts
```

If the `*` under `CURRENT` is next to the `kind-gitops-development` context, you're good to go. If not, use

```
kubectl config use-context kind-gitops-development
```

Now you're set to interact with the right cluster.

Before applying, we'll want to create a namespace into which to deploy. We'll do that with

```
kubectl create namespace simple-http-server-manual
```

This namespace will indicate that we're deploying here manually with kubectl.

Now we're ready to apply our manifest to get our deployment running in the cluster.

```
kubectl apply -f yaml-manifests/simple-http-server-deployment.yaml -n simple-http-server-manual
```

## Verify the running deployment

Now you should be able to see your running deployment and the associated pod in the cluster.

```
kubectl get deployment -n simple-http-server-manual
```

should yield output like

```
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
simple-http-server-deployment   1/1     1            1           22s
```

and

```
kubectl get pod -n simple-http-server-manual
```

should yield output like

```
NAME                                            READY   STATUS    RESTARTS   AGE
simple-http-server-deployment-f799db4f5-fkpm6   1/1     Running   0          34s
```

This proves that we have craeted a deployment with a running pod from the image we created using code we wrote and a Dockerfile to create an image.

We haven't done anything we can call GitOps just yet. We're not done, though.
