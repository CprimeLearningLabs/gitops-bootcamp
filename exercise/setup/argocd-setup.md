# Adding ArgoCD to the cluster

Among the options for tools to use for GitOps, ArgoCD is a top choice. It's what we'll use for these labs.

There are other options, but usign ArgoCD will both demostrate the principles and ideas of GitOps and give you real experience with using a tool created from a mindset of doing pull-based deployment with Git as the source of truth.

## Use Helm to install ArgoCD in your clusters

Ultimately, we're going to simulate promoting new application versions from environment to environment. To that end, we've created distinct Kubernetes clusters to represent a development and a production environment.

We want to install ArgoCD into both clusters. This is a decision we're making consciously, knowing there are other options. If you have questions about other ways, please ask your instructor.

First, we'll want to set up the Helm repository for ArgoCD and update it to get information about the charts available there.

```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

Then, connect to each kubernetes context in turn with Kubectl, create a namespace for ArgoCD, and install the chart.

```
kubectl config use-context kind-gitops-development
kubectl create namespace argocd
helm upgrade --install argocd argo/argo-cd -n argocd --set "server.extraArgs={--insecure}" --set "server.ingress.enabled=true"
kubectl config use-context kind-gitops-production
kubectl create namespace argocd
helm upgrade --install argocd argo/argo-cd -n argocd --set "server.extraArgs={--insecure}" --set "server.ingress.enabled=true"
```

