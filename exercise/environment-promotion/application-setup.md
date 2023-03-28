# Setting up ArgoCD applications for different environments

To deploy versions of our application to our different environments, we need to have ArgoCD applications for each one with minor differences in how they are configured. We'll also need to set up a strategy for how to distinguish what goes where and to enable promotion through the environments.

## Create environment branches

There are many strategies for how to distinguish version that belong in differing environments. These different possibilities are worthy of discussion and you should have done that with your instructor. Please ask questions if you want to know more. For our purposes, we'll use Git branches as our mechanism for distinguishing and promotion.

To prepare for promoting versions, there are a couple more things we want to do. One is to create new brancches in the infrastructure repository. Create two new branches, both pointing to the same commit and push them to the remote server.

```
git checkout -b development
git push --set-upstream origin development
git checkout -b production
git push --set-upstream origin production
```

Now, we have branches that represent our environment. They currently both point to the same commit. After we get the ArgoCD applications set up properly, this will help in getting the right version deployed to the right environment.

## Updating the Development application

The ArgoCD application we've been using for synchronizing the development envirionment is currently referencing the default branch (usually `master` or `main`). Let's be more purposeful in using a branch to represent an environment and update to the application to instead use the ref called `development`.

We'll do this with kubectl in the declarative style.

Edit the declarative manifest we created before. We called this file `declarative-application-development.yaml`.

The edit we'll make is to change the element at `spec.source.targetRevision` from `master` to `development`.

Now, the manifest will look like:

``` yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: simple-http-server-argo-declarative
  namespace: argocd
spec:
  project: default
  source:
    repoURL: <Your Infrastrcture Repository URL>
    targetRevision: development
    path: yaml-manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: simple-http-server-argo-declarative
  syncPolicy:
    automated: {}
    syncOptions:
    - CreateNamespace=true
```

Like before, update the application with

```
kubectl apply -f declarative-application-development.yaml
```

## Creating the Production application

So far, we've dealt only with our development environment. We'll want to create an ArgoCD application for production that is nearly identical to the development one, with only minor differences.

First, copy the declarative manifest we created for development. We called this file `declarative-application-development.yaml`. We'll create one like it for production and call it ``declarative-application-production.yaml``

The edit we'll make is to change the element at `spec.source.targetRevision` from `development` to `production`.

Now, the manifest will look like:

``` yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: simple-http-server-argo-declarative
  namespace: argocd
spec:
  project: default
  source:
    repoURL: <Your Infrastrcture Repository URL>
    targetRevision: production
    path: yaml-manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: simple-http-server-argo-declarative
  syncPolicy:
    automated: {}
    syncOptions:
    - CreateNamespace=true
```

Because we've chosen the strategy of using different ArgoCD instances in the different clusters rather than using one cluster with applications for the different environments, we'll first need to switch the context kubectl is using to make sure we apply this manifest in the right cluster.

```
kubectl config use-context kind-gitops-production
```

It's a good idea to confirm the context switch happened as expected by verifying that the producion cluster now has the `*` indicating current in

```
kubectl config get-contexts
```

With this context switch made, go ahead and create the application for production:

```
kubectl apply -f declarative-application-production.yaml
```

You should see this new application sync in the same as as did the one for development. You'll be able to see resources created in the production cluster in the same way we did in the development cluster via any and all of the ArgoCD web interface, the ArgoCD command-line interface, kubectl, and requesting the application via the newly minted ingress in the cluster. If you followed the configuration of the clusters in this lab guide, your development cluster will be responding on port 8080 on your workstation and your production cluster on port 80.

This means you should be able to reach your deployed production application on `http://localhost/simple-http-server`. You can do this with your browser and or:

```
curl http://localhost/simple-http-server
```

Congratulations, you have set up Kubernetes environments for both development and production.
