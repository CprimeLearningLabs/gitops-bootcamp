# Create an application in ArgoCD via Declarative Setup

We've caught a glimpse in prior labs at what ArgoCD is doing in our cluster when we create an application.

Essentially, it's really just creating a cluster resource, using a [custom resource definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) created as a result of installing ArgoCD.

It might have occured to you that you could create such a resource directly with kubectl. In fact, you can and that's exaactly what we'll do in this lab.

ArgoCD calls this way of creating applications [Declarative Setup](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/). The documentation linked here is quite informative and helpful.

## Creating a manifest for an ArgoCD application

Several values are needed for input to create an application. For this reason, the most straightforward way to create an ArgoCD application resource in a Kubernetes cluster via kubectl is to apply a file with a manifest for the resource.

An application, in a very simple form, lifted directly from the ArgoCD declarative setup documentation looks something like this:

``` yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: guestbook
```

We'll want to take this template and flesh it out further to create an application just like the ones we've created in the prior labs. Create a file on your disk called `declarative-application-development.yaml` and fill it with the following YAML content (replacing `<Your Infrastrcture Repository URL>` with the URL of your infrastructure repository and `<The default branch in your repository>` with your default branch name, which will usually be either `master` or `main`):


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
    targetRevision: <The default branch in your repository>
    path: yaml-manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: simple-http-server-argo-declarative
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
```

Now, apply this manifest to the cluster with

```
kubectl apply -f declarative-application-development.yaml
```

You should now see that another application has been created.

```
kubectl get application -n argocd
```

Currently, you should see the application in an `OutOfSync` and `Missing` state, as in our prior labs. No namespace has been created, nor has any resource in that namespace until a synchronization happens.

We could use the ArgoCD web interface or command line interface to perform a sync. Instead of doing that, in the next lab we'll see another way of getting the application to synchronize.
