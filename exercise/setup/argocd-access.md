# Accessing ArgoCD

ArgoCD is a GitOps controller that operates inside a Kubernetes cluster. There's a lot more to it than a user interface.

It has a web-based user interface, though, and we'll want to access it via the browser to make certain we have installed ArgoCD successfully. Before we can do that, we'll need to install an ingress controller in the cluster. An ingress controller manages allowing the world outside the cluster to have a window into services provided by the cluster.

We'll use the Nginx Ingress Controller for this purpose.

To install the ingress controller into both clusters, use kubectl to switch to the appropriate context for each cluster and to install a manifest set up to work with our kind clusters.

```
kubectl config use-context kind-gitops-development
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl config use-context kind-gitops-production
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Now that we have clusters set up to respond to traffic on different ports for our two clusters, ArgoCD installed with an ingress resource set up, and an ingress controller, we should be able to reach the ArgoCD user interface via either cURL or the browser.

The configuration we used for setting up our kind clusters made it such that you should be able to reach the ArgoCD user interface for the development cluster at `http://localhost:8080` and the production cluster at `http://localhost`.

We don't need to worry about logging in just yet. We'll come back to that. For now, if you can see the page serve, you are successful in setup.
